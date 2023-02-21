class ApplicationController < ActionController::Base
  
  include Authentication
  include SetCurrentRequestDetails
  include Pagy::Backend
  
  helper_method :darken, :lighten
  
  before_action :set_active_storage_current_host
  
  def set_active_storage_current_host
    ActiveStorage::Current.host = request.base_url
  end

  def darken(html_code, percentage = 85)
    Color::RGB
      .from_html(html_code)
      .darken_by(percentage)
      .html
  end

  def lighten(html_code, percentage = 85)
    Color::RGB
      .from_html(html_code)
      .lighten_by(percentage)
      .html
  end

  def get_dates
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : (Date.today - 6.month).beginning_of_month
    @end_date = (Date.today - 1.month).end_of_month
  end
end
