class MessagesController < ApplicationController

  before_action :check_auth
  def create
    params[:id]=''
    params[:message][:id] = ''
    @message = Message.create(message_params)
    render json: @message.id
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @message.id }
    # end
  end

  def update
    @message = Message.find(params[:id])
    @messages = @message.update_attributes(message_params) unless @message.nil?
    render json: @message.id
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @messages }
    # end
  end

  private

  def message_params
    params.require(:message).permit(:user, :id, :theme, :text,:status, message: [:id, :user, :theme,:text,:status])
  end

end
