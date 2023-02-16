class ImportsController < ApplicationController

  def index    
    @account = Account.find_by(id: params[:account_id]) if params[:account_id]

    @import = Import.new(account: @account)
    @previous_imports = Import.all.order(created_at: :desc)
  end

  def show
    @import = Import.find(params[:id])
  end

  def create

    @import = Import.new(import_params)
    @import.save!

    if @import.import!
      redirect_to import_path(@import)
    else
      redirect_to imports_path
    end
  end

  def status
    @import = Import.find(params[:id])
    render json: { status: @import.status }
  end

  private

  def import_params
    params.require(:import).permit(:file, :account_id)
  end
end