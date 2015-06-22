class ReasonsController < ApplicationController

  before_action :check_auth
  def create
    params[:id]=''
    params[:reason][:id] = ''
    @reason = Reason.create(reason_params)
    render json: @reason.id
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @reason.id }
    # end
  end

  def update
    @reason = Reason.find(params[:id])
    @reasons = @reason.update_attributes(reason_params) unless @reason.nil?
    render json: @reason.id
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @reasons }
    # end
  end

  private

  def reason_params
    params.require(:reason).permit(:user, :id, :name, :period, :duration_day, :status, reason: [:id, :user, :name,:period, :duration_day, :status])
  end

end
