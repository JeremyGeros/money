class GroupingsController < ApplicationController
  before_action :require_user

  def show
    if params[:category].present?
      @spends = Spend.where(category: params[:category])
      @name = params[:category].humanize
    elsif params[:spend_group].present?
      @spends = Spend.where(spend_group: params[:spend_group])
      @name = params[:spend_group].humanize
    elsif params[:name].present?
      @spends = Spend.where(name: params[:name])
      @name = params[:name].humanize
    end

    get_dates
    @transactions = Transaction.where(spend: @spends).order(made_at: :desc, id: :desc).includes(spend: {icon_attachment: :blob}).where(made_at: @start_date..@end_date)
  end

end