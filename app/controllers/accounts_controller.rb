class AccountsController < ApplicationController
  before_action :require_user
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.all.order(:id)

    get_dates
  end

  def show
    Transaction.unscoped do
      @transactions = @account.transactions.order(made_at: :desc, id: :desc).includes(spend: {icon_attachment: :blob})
    end
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    
    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
    end
  end


  def transactions
    @pagy, @transactions = pagy(Transaction.all.order(made_at: :desc, id: :desc).includes(account: {logo_attachment: :blob}, spend: {icon_attachment: :blob}))
    render partial: 'transactions/list', locals: { transactions: @transactions, show_account: true }
  end

  def all_spends_chart
    get_dates

    data = Spend.categories.keys.map do |category|
      next nil if ['rent', 'other', 'cafe', 'restaurant', 'supermarket'].include?(category)

      data = Transaction.where(spend: Spend.where(category: category)).between(@start_date, @end_date).where('amount < 0').group_by_month(:made_at).sum(:amount)

      next nil if data.values.sum == 0

      data.map do |d, amount|
        data[d] = amount * -1
      end

      { name: category.titleize, data:  data}
    end.compact

    render json: data.chart_json
  end

  private

    def get_dates
      @start_date = params[:start_date] ? Date.parse(params[:start_date]) : (Date.today - 6.month).beginning_of_month
      @end_date = (Date.today - 1.month).end_of_month
    end

    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :currency, :bank, :account_number, :logo, :starting_balance)
    end


end