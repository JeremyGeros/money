class MatchersController < ApplicationController
  before_action :require_user
  before_action :set_matcher, only: [:show, :edit, :update, :destroy]

  def index
    @matchers = Matcher.all.order(:match_regex)
  end

  def show
  end

  def new
    @matcher = Matcher.new(enabled: true)
  end

  def edit
  end

  def create
    @matcher = Matcher.new(matcher_params)
    
    respond_to do |format|
      if @matcher.save
        format.html { redirect_to @matcher, notice: 'Matcher was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @matcher.update(matcher_params)
        format.html { redirect_to @matcher, notice: 'Matcher was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @matcher.destroy
    respond_to do |format|
      format.html { redirect_to matchers_url, notice: 'Matcher was successfully destroyed.' }
    end
  end

  private

    def set_matcher
      @matcher = Matcher.find(params[:id])
    end

    def matcher_params
      params.require(:matcher).permit(:match_regex, :replacer, :account_id, :enabled, :enabled_at)
    end


end