class PagesController < ApplicationController

  before_action :check_auth, except: [:index, :create]
  before_action :check_agents_confirmation, only: :index
  # before_action :start_daemon, only: :index
  # TODO перенести в демон
  # after_action :clean_up_friends, only: :index
  # after_action :clean_up_leafs, only: :index
  # after_action :my_daemon, only: :index


  def index
    @page = make_pages_hash
    respond_to do |format|
      format.html
      format.json { render json: @page }
    end
  end

  def update
    @user = User.find(params[:id])
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
  def make_pages_hash
    pages_hash = {
        # env: Rails.env,
        language: locale,
        badSlides: [],
        goodSlides: []
    }
    if Rails.env.production?
      BAD_SLIDES.each do |f|
        pages_hash[:badSlides] << {image: ActionController::Base.helpers.asset_path(f[:image]),text: f[:text]}
      end
      GOOD_SLIDES.each do |f|
        pages_hash[:goodSlides] << {image: ActionController::Base.helpers.asset_path(f[:image]),text: f[:text]}
      end
    else
      GOOD_SLIDES.each do |f|
        pages_hash[:goodSlides] << {image: '/assets/' + f[:image],text: f[:text]}
      end
      BAD_SLIDES.each do |f|
        pages_hash[:badSlides] << {image: '/assets/' + f[:image],text: f[:text]}
      end
    end
    pages_hash
  end

  def check_agents_confirmation
    User.where(name: WAIT_CONFIRM).each do |u|
      if u.confirmed?
        Agent.update(u.status,img:CONFIRMED) && u.delete
      else
        if u.confirmation_sent_at < 2.days.ago
          Agent.find(u.status).delete
          u.delete
        end
      end
    end
  end

  def user_params
    # (:id,:email,:name,:gender,:status,:paid,:birthday, :cycle_day,:begin)
    params.require(:page).permit(:id,:email,:name,:gender,:status,:paid,:birthday,:cycle_day,:begin, page:[:id,:email,:name,:gender,:status,:paid,:birthday,:cycle_day,:begin])
  end

  def pages_params
    params.require(:page).permit(:email, page:[:email])
  end

end
