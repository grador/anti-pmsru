class LettersController < ApplicationController
  before_action :check_auth

  def show
    @letter = Letter.find(params[:id])
    FriendsMailer.notify_letter(@letter).deliver_later
    History.create(user_id: @letter.user, letter_id: @letter.id, status: NOTIFY_MAIL_SENT)
    render json: @letter.id
  end

  def create
    params[:id]=''
    params[:letter][:id] = ''
    @letter = Letter.create(letter_params)
    render json: @letter.id
  end

  def update
    @letter = Letter.find(params[:id])
    @letters = @letter.update_attributes(letter_params) if @letter
    render json: @letter.id
  end

  def destroy
    @letter =  Letter.find(params[:id])
     if @letter
       @letter = @letter.delete
       render json: @letter.id
     else
       render json: params[:id]
     end
  end

  private

  def letter_params
    params.require(:letter).permit(:user, :id, :event_id, :agent, :from_id,:message_id, :status, letter: [:id, :user, :event_id,:agent, :from_id,:message_id,:status])
  end

end
