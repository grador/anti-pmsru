class ImagesController < ApplicationController
  require 'class_method'
  respond_to :json
  before_action :check_auth

  def create
    @image = Image.save(params[:file],current_user)
    render json: make_true_path(@image.url)
  end

  private
  def make_true_path(url)
    if Rails.env.production?
      path = ActionController::Base.helpers.asset_path(url)
      path.match('assets') || path == ''? path : '/images/' + url
    else
      '/assets/' + url
    end
  end
end
