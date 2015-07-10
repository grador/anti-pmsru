include PublicMethods
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'sidekiq/api'
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  respond_to :json
  rescue_from ActionController::RoutingError, :with => :go_to_root
  rescue_from ActionController::BadRequest, :with => :go_to_root
  rescue_from ActionController::RenderError, :with => :go_to_root
  rescue_from ActionController::MethodNotAllowed, :with => :go_to_root
  rescue_from ActionController::InvalidAuthenticityToken, :with => :go_to_root
  rescue_from ActionController::UnknownFormat, :with => :go_to_root
  rescue_from ActiveRecord::RecordNotFound, :with => :go_to_root
  rescue_from ActiveRecord::RecordNotSaved, :with => :go_to_root


  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  HardWorker.perform_async

  def go_to_root
    redirect_to root_url
  end

  def check_auth
    redirect_to root_url unless user_signed_in?
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email,:name,:password,:password_confirmation,:gender, :status, :paid,:birthday,:cycle_day,:begin) }
  end

end
