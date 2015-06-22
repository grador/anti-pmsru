class AgentsController < ApplicationController
  before_action :check_auth

  def create
    params[:id]=''
    params[:agent][:id] = ''
    @agent = Agent.create(agent_params).send_confirmation
    render json: @agent.id
  end
  def update
    @agent = Agent.find(params[:id])
    @agents = @agent.update_attributes(agent_params) unless @agent.nil?
    render json: @agent.id
  end

  private

  def agent_params
    params.require(:agent).permit(:user, :id, :name, :email, :img, :status, agent: [:id, :user, :name,:email, :img, :status])
  end

end
