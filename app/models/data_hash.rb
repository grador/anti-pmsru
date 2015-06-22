require 'singleton'
require 'class_method'

class DataHash

  include Singleton

  attr_accessor :user, :agents, :froms, :messages, :reasons, :friends

  def initialize
    @user = ''
    @agents = []
    @froms = []
    @messages = []
    @reasons = []
    @friends = []
    # @user ||= current_user
    # @agents ||= Agent.where({ user: [@user.id, 0]}).select(:id,:user,:name,:email,:img,:status).order('user DESC').as_json
    # @froms ||= From.where({ user: [@user.id, 0]}).select(:id,:user,:email,:status).order('user DESC').as_json
    # @messages ||= Message.where({ user: [@user.id, 0]}).select(:id,:user,:theme,:text,:status).order('user DESC').as_json
    # @reasons ||= Reason.where({ user: [@user.id, 0]}).select(:id,:user,:name,:period,:duration_day,:status).order('user DESC').as_json
    # @friends ||= []
  end

  # DataHash.new

  def publish(user)
    p user
    self.user = user
    p self.user
    self.agents = Agent.where({ user: [user.id, 0]}).select(:id,:user,:name,:email,:img,:status).order('user DESC').as_json
    self.froms = From.where({ user: [@ser.id, 0]}).select(:id,:user,:email,:status,:name).order('user DESC').as_json
    self.messages = Message.where({ user: [user.id, 0]}).select(:id,:user,:theme,:text,:status).order('user DESC').as_json
    self.reasons = Reason.where({ user: [user.id, 0]}).select(:id,:user,:name,:period,:duration_day,:status).order('user DESC').as_json
    self.friends = user.friends.where("status!=?",DELETED_SAVED).select(:id,:user_id,:name,:img,:cycle_day,:status)
                          .as_json(include:{events:{
                                       include: {letters:{only:[:id,:user,:event_id,:agent_id,:from_id,:message_id,:status]}},
                                       only:[:id,:user,:friend_id,:reason_id,:begin_date,:period,:duration_day,:shift_day,:color,:status]}})

    # self.user = user
    # self.agents = agents
    # self.froms = froms
    # self.messages = messages
    # self.reasons = reasons
    # self.friends = friends
  end

  def self.clean
    instance.user = ''
    instance.agents = []
    instance.froms = []
    instance.messages = []
    instance.reasons = []
    instance.friends = []
  end

end