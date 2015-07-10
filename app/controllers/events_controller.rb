class EventsController < ApplicationController
  before_action :check_auth
  def show
    @event = Event.find(params[:id])
    Letter.send_notify_letters(@event.letters)
    render json: @event.id
  end

  def create
    params[:id]=''
    params[:event][:id] = ''
    @event = Event.create(event_params)
    render json: @event.id
  end

  def update
    @event = Event.find(params[:id])
    @events = @event.update_attributes(event_params) if @event
    render json: @event.id
  end

  def destroy
    @event = Event.find(params[:id])
    if @event
      @event = @event.destroy
      render json: @event.id
    else
      render json: params[:id]
    end
  end

  private

  def event_params
    params.require(:event).permit(:user, :id, :friend_id, :reason_id, :begin_date,:period,:duration_day,:shift_day,:color, :status, event: [:id, :user, :friend_id,:reason_id, :begin_date,:period,:duration_day,:shift_day,:color, :status])
  end

end
