class SpendsController < ApplicationController
  before_action :require_user
  before_action :set_spend, only: [:show, :edit, :update, :destroy]

  def index
    @spends = Spend.all.order(:name)
  end

  def show
  end

  def new
    @spend = Spend.new
  end

  def edit
  end

  def create
    @spend = Spend.new(spend_params)
    
    respond_to do |format|
      if @spend.save
        format.html { redirect_to @spend, notice: 'Spend was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @spend.update(spend_params)
        format.html { redirect_to @spend, notice: 'Spend was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @spend.destroy
    respond_to do |format|
      format.html { redirect_to spends_url, notice: 'Spend was successfully destroyed.' }
    end
  end

  private

    def set_spend
      @spend = Spend.find(params[:id])
    end

    def spend_params
      params.require(:spend).permit(:name, :category, :spend_group, :always_positive, :icon, :ignored, :generic, :kind, lookups: [])
    end


end