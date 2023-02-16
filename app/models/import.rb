require 'pdf-reader'
require 'csv'

class Import < ApplicationRecord
  belongs_to :account

  has_one_attached :file

  validates :file, presence: true
  validates :account, presence: true

  enum status: { pending: 0, processing: 1, imported: 2, failed: 3 }

  before_validation :set_defaults, on: :create

  # validates :name, presence: true, uniqueness: { scope: :account_id }

  def set_defaults
    self.status ||= :pending
    self.name ||= file.filename.to_s
  end

  def import!
    self.processing!

    transactions_imported = 0

    rows = case account.bank
    when 'banorte'
      banorte_parse
    when 'fondeadora'
      fondeadora_parse
    when 'bnz_nz'
      bnz_nz_parse
    when 'bnz_usd'
      bnz_usd_parse
    else
      []
    end

    rows.each do |row|
      transaction = Transaction.where(details: row[:details], account: account, amount: row[:amount], made_at: row[:date]).first
      transaction ||= Transaction.new

      transaction.update!(
        account: account,
        made_at: row[:date],
        details: row[:details],
        amount: row[:amount],
        balance: row[:balance],
        name: transaction.name || row[:name],
      )

      transactions_imported += 1
    end

    self.update!(total_transactions: transactions_imported)
    self.imported!
  rescue => e
    self.failed!
    raise e if Rails.env.development?
  end

  def pdf_reader
    reader ||= begin
      _reader = nil
      self.file.open do |file|
        _reader = PDF::Reader.new(file.path)
      end
      _reader
    end
  end

  def banorte_parse
    transaction_rows = []

    pdf_reader.pages.each_with_index do |page, index|
      next if index == 0

      rows = page.text.split("\n")

      last_valid_row = nil

      rows.each do |row|
        next if row.empty? || row.include?('SALDO ANTERIOR') || row.include?('SALDO ACTUAL') || row.include?('SIN MOVIMIENTOS')

        date_row = row.match(/^ (\d\d\-\w\w\w\-\d\d)(.+?\s\s\s)(\d.+?\s\s\s)(\d.+)/)
        if date_row&.captures.try(:[], 0)&.present?
          details = date_row.captures[1].strip.gsub("\u0000", '')

          trans = {
            date: Date.parse(to_english_date(date_row.captures[0].strip)),
            details: details,
            amount: amount_debit_or_credit(date_row.captures[2].strip.gsub(',', '').to_f, details),
            balance: date_row.captures[3].strip.gsub(',', '').to_f,
            name: details.split('RFC:').first,
          }

          last_valid_row = trans

          transaction_rows << trans
        end

        if row.start_with?(/\s{11}\w/)
          last_valid_row[:details] += row.strip
          last_valid_row[:name] = last_valid_row[:details].split('RFC:').first
        end
      end
    end

    transaction_rows
  end

  def fondeadora_parse
    transaction_rows = []

    pdf_reader.pages.each_with_index do |page, index|
      next if index == 0

      rows = page.text.split("\n")

      rows.each do |row|
        next if row.empty?

        date_row = row.match(/^ (\w\w\w\s\d\d)(.+?\s\s\s)(\-?\$\d.+)/)
        if date_row&.captures.try(:[], 0)&.present?
          details = date_row.captures[1].strip.gsub("\u0000", '')

          trans = {
            date: Date.parse(to_english_date(date_row.captures[0].strip)),
            details: details,
            amount: date_row.captures[2].strip.gsub("$", '').gsub(',', '').to_f,
            name: details,
          }
          transaction_rows << trans
        end
      end

    end

    transaction_rows
  end

  def bnz_nz_parse
    transaction_rows = []

    CSV.parse(self.file.download, headers: true).map do |row|
      transaction_rows << {
        date: Date.strptime(row['Date'], "%d/%m/%y"),
        details: row['Payee'].gsub("\u0000", ''),
        amount: row['Amount'].to_f,
        name: row['Payee'],
      }
    end

    transaction_rows
  end

  def bnz_usd_parse
    transaction_rows = []

    pdf_reader.pages.each_with_index do |page, index|

      rows = page.text.split("\n")

      rows.each do |row|
        next if row.empty?

        date_row = row.match(/(\d\d\s\w\w\w)\s+?\d\d\s\w\w\w\s+?(\w.+?)\s\s\s\s\s\s{10,}(\d\S+)/)
        if date_row&.captures.try(:[], 0)&.present?
          details = date_row.captures[1].strip.gsub("\u0000", '')

          trans = {
            date: Date.parse(to_english_date(date_row.captures[0].strip)),
            details: details,
            amount: amount_debit_or_credit(date_row.captures[2].strip.gsub("$", '').gsub(',', '').to_f, details),
            name: details,
          }
          transaction_rows << trans
        end
      end
    end

    transaction_rows
  end

  def to_english_date(date)
    date.gsub(/ENE/i, 'Jan')
        .gsub(/FEB/i, 'Feb')
        .gsub(/MAR/i, 'Mar')
        .gsub(/ABR/i, 'Apr')
        .gsub(/MAY/i, 'May')
        .gsub(/JUN/i, 'Jun')
        .gsub(/JUL/i, 'Jul')
        .gsub(/AGO/i, 'Aug')
        .gsub(/SET/i, 'Sep')
        .gsub(/OCT/i, 'Oct')
        .gsub(/NOV/i, 'Nov')
        .gsub(/DIC/i, 'Dec')
  end

  def amount_debit_or_credit(amount, details)
    if details.include?('SPEI RECIBIDO') || details.include?("INTEREST") || details.include?("REBATE OF FEE")
      amount 
    else
      amount * -1
    end
  end
end