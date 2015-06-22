class FromsController < ApplicationController
  before_action :check_auth

  def create
    params[:id]=''
    params[:from][:id] = ''
    @from = From.create(from_params)
    render json: @from.id
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @from.id }
    # end
  end

  def update
    @from = From.find(params[:id])
    @froms = @from.update_attributes(from_params) unless @from.nil?
    render json: @from.id
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @froms }
    # end
  end

  private

  def from_params
    params.require(:from).permit(:user, :id, :email,:status, :name, from: [:id, :user,:email,:status, :name])
  end

end
