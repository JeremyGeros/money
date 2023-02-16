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

  def spent_between(from_date, to_date, formatted: true, kinds: Transaction.kinds.keys)
    @spent_between = Account.all.sum { |a| a.spent_between(from_date, to_date, to_currency: "MXN", kinds: kinds) }
    formatted ? display_amount_colored(@spent_between, 'MXN') : @spent_between
  end

  def made_between(from_date, to_date, formatted: true, kinds: Transaction.kinds.keys)
    @made_between = Account.all.sum { |a| a.made_between(from_date, to_date, to_currency: "MXN", kinds: kinds) }
    formatted ? display_amount_colored(@made_between, 'MXN') : @made_between
  end

  def net_between(from_date, to_date, formatted: true, kinds: Transaction.kinds.keys)
    @net_between = made_between(from_date, to_date, formatted: false, kinds: kinds) + spent_between(from_date, to_date, formatted: false, kinds: kinds)
    formatted ? display_amount_colored(@net_between, 'MXN') : @net_between
  end

  def monthly_avg_spent_between(from_date, to_date, formatted: true, kinds: Transaction.kinds.keys, spend: nil)
    @monthly_avg_spent_between = Account.all.sum { |a| a.spent_between(from_date, to_date, spend: spend, to_currency: "MXN", kinds: kinds) } / month_difference(from_date, to_date)

    formatted ? display_amount_colored(@monthly_avg_spent_between, 'MXN') : @monthly_avg_spent_between
  end

  def monthly_avg_made_between(from_date, to_date, formatted: true, kinds: Transaction.kinds.keys)
    @monthly_avg_made_between = Account.all.sum { |a| a.made_between(from_date, to_date, to_currency: "MXN", kinds: kinds, kinds: kinds) } / month_difference(from_date, to_date)
    
    formatted ? display_amount_colored(@monthly_avg_made_between, 'MXN') : @monthly_avg_made_between
  end

  def monthly_avg_net_between(from_date, to_date, formatted: true, kinds: Transaction.kinds.keys)
    @monthly_avg_net_between = monthly_avg_made_between(from_date, to_date, formatted: false, kinds: kinds) + monthly_avg_spent_between(from_date, to_date, formatted: false, kinds: kinds)

    formatted ? display_amount_colored(@monthly_avg_net_between, 'MXN') : @monthly_avg_net_between
  end
end