class AccountsController < ApplicationController
  before_action :require_user
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.all

    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : (Date.today - 6.month).beginning_of_month
    @end_date = (Date.today - 1.month).end_of_month
  end

  def transactions
    @pagy, @transactions = pagy(Transaction.all.order(made_at: :desc, id: :desc).includes(account: {logo_attachment: :blob}, spend: {icon_attachment: :blob}))
    render partial: 'transactions/list', locals: { transactions: @transactions, show_account: true }
  end

  def show
    @transactions = @account.transactions.order(made_at: :desc, id: :desc).includes(spend: {icon_attachment: :blob})
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

  private

    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :currency, :bank, :account_number, :logo, :starting_balance)
    end


end