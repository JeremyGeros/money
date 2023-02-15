module MoneyHelper


  def total_mxn_balance
    @total_mxn_balance = Account.mxn.sum(&:balance)

    Account.where.not(currency: 'mxn').each do |account|
      a_balance = account.balance
      @total_mxn_balance += Money.from_amount(a_balance, account.currency).exchange_to('MXN').to_f
    end

    display_amount_colored(@total_mxn_balance, 'MXN')
  end

  def only_mxn_balance
    @only_mxn_balance = Account.mxn.sum(&:balance)
    display_amount_colored(@only_mxn_balance, 'MXN')
  end

  def spent_between(from_date, to_date, formatted: true)
    @spent_between = Account.all.sum { |a| a.spent_between(from_date, to_date, to_currency: "MXN") }
    formatted ? display_amount_colored(@spent_between, 'MXN') : @spent_between
  end

  def made_between(from_date, to_date, formatted: true)
    @made_between = Account.all.sum { |a| a.made_between(from_date, to_date, to_currency: "MXN") }
    formatted ? display_amount_colored(@made_between, 'MXN') : @made_between
  end

  def net_between(from_date, to_date, formatted: true)
    @net_between = made_between(from_date, to_date, formatted: false) + spent_between(from_date, to_date, formatted: false)
    formatted ? display_amount_colored(@net_between, 'MXN') : @net_between
  end

  def monthly_avg_spent_between(from_date, to_date, formatted: true, spend: nil)
    @monthly_avg_spent_between = Account.all.sum { |a| a.spent_between(from_date, to_date, spend: spend, to_currency: "MXN") } / month_difference(from_date, to_date)

    formatted ? display_amount_colored(@monthly_avg_spent_between, 'MXN') : @monthly_avg_spent_between
  end

  def monthly_avg_made_between(from_date, to_date, formatted: true)
    @monthly_avg_made_between = Account.all.sum { |a| a.made_between(from_date, to_date, to_currency: "MXN") } / month_difference(from_date, to_date)
    
    formatted ? display_amount_colored(@monthly_avg_made_between, 'MXN') : @monthly_avg_made_between
  end

  def monthly_avg_net_between(from_date, to_date, formatted: true)
    @monthly_avg_net_between = monthly_avg_made_between(from_date, to_date, formatted: false) + monthly_avg_spent_between(from_date, to_date, formatted: false)

    formatted ? display_amount_colored(@monthly_avg_net_between, 'MXN') : @monthly_avg_net_between
  end
end