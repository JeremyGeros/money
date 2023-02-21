class GroupingsController < ApplicationController
  before_action :require_user

  def show
    get_dates

    if params[:category].present?
      @spends = Spend.where(category: params[:category])
      @name = params[:category].humanize
    elsif params[:spend_group].present?
      @spends = Spend.where(spend_group: params[:spend_group])
      @name = params[:spend_group].humanize
    elsif params[:name].present?
      @spends = Spend.where(name: params[:name])
      @name = params[:name].humanize
    elsif params[:recurring].present?
      @name = 'Recurring transactions'
      @transactions = Transaction.where(kind: :recurring)
    elsif params[:one_off].present?
      @name = 'One-off transactions'
      @transactions = Transaction.where(kind: :one_off)
    elsif params[:ignored].present?
      @name = 'Ignored transactions'
      @transactions = Transaction.where(ignored: true)
    elsif params[:personal_transfer].present?
      @name = 'Personal transfers'
      @transactions = Transaction.where(personal_transfer: true)
    end

    @transactions ||= Transaction.where(spend: @spends)
    @transactions = @transactions.order(made_at: :desc, id: :desc).includes(:account, spend: {icon_attachment: :blob}).where(made_at: @start_date..@end_date)
  end

end