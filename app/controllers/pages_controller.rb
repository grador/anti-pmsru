class PagesController < ApplicationController

  before_action :check_auth, except: [:index, :create]
  # TODO перенести в демон
  after_action :clean_up_friends, only: :index
  after_action :clean_up_leafs, only: :index
  # after_action :my_daemon, only: :index


  def index
    # p Agent.all
    # p From.all
    # p Message.all
    # p Reason.where(id:[10 ...20])
    # p User.all
    @page = {language: locale}
    respond_to do |format|
      format.html
      format.json { render json: @page }
    end
  end

  def update
    @user = User.find(params[:id])
    p @user
    if @user.allowed_editing?
      @user.update_attributes(user_params)
    else
      @user= User.new(id: @user? 0:-1)
    end
    render json: @user.id
  end

  def change
    @user = User.find(params[:id])
    if @user.allowed_editing?
      if @user.valid_password?(params[:password])
        @user.reset_password!(params[:password_confirmation], params[:password_confirmation])
      else
        @user= User.new(id:-1)
      end
    else
      @user= User.new(id:0)
    end
    render json: @user.id
  end

  def create
    @user = User.where(email: params[:page][:email]).first
    if @user.allowed_editing?
      @user.send_reset_password_instructions
    else
      @user= User.new(id: @user? -1:0)
    end
    render json: @user.id
  end

  private

  def user_params
    # (:id,:email,:name,:gender,:status,:paid,:birthday, :cycle_day,:begin)
    params.require(:page).permit(:id,:email,:name,:gender,:status,:paid,:birthday,:cycle_day,:begin, page:[:id,:email,:name,:gender,:status,:paid,:birthday,:cycle_day,:begin])
  end

  def pages_params
    params.require(:page).permit(:email, page:[:email])
  end

end
