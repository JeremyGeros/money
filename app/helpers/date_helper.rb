module DateHelper
  
  def last_6_months
    months = [
      (Date.today.beginning_of_month - 6.months),
      (Date.today.beginning_of_month - 5.months),
      (Date.today.beginning_of_month - 4.months),
      (Date.today.beginning_of_month - 3.months),
      (Date.today.beginning_of_month - 2.months),
      (Date.today.beginning_of_month - 1.months),
    ]

    months.map { |m| {name: m.strftime('%b %Y'), start: m} }
  end

  def dates_range_display(from_date, to_date)
    from_date.month == to_date.month ? from_date.strftime('%b') : "#{from_date.strftime('%b')} - #{to_date.strftime('%b')}"
  end

  def month_difference(from_date, to_date)
    (to_date.year * 12 + to_date.month) - (from_date.year * 12 + from_date.month) + 1
  end
end