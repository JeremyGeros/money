class ImportsController < ApplicationController

  def index    
    @import = Import.new(params[:import].permit(:account_id))
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
      render :index
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