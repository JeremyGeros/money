class TransactionsController < ApplicationController
  before_action :require_user
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.all.order(made_at: :desc, id: :desc)

    if params[:without_spend]
      @transactions = @transactions.where(spend_id: nil)
    end
  end

  def show
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)
    
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transaction_url, notice: 'Transaction was successfully destroyed.' }
    end
  end

  private

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:name, :details, :amount, :balance, :made_at, :account_id, :spend_id, :personal_transfer, :kind, :ignored)
    end


end