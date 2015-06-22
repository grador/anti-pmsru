class ImagesController < ApplicationController
  require 'class_method'
  respond_to :json
  before_action :check_auth

  def create
    @image = Image.save(params[:file],current_user)
    render json: @image.url
  end

end
