class FriendsController < ApplicationController
  include PublicMethods
  before_action :check_auth

  def index
    @data = make_data_hash(current_user)
    respond_to do |format|
      format.html
      format.json { render json: @data }
    end
  end

  def show
    @friend = Friend.find(params[:id])
    Letter.send_notify_letters(@friend.letters)
    render json: @friend.id
  end

  def destroy
    @friend = Friend.find(params[:id])
    if @friend
      @friend = @friend.destroy
      render json: @friend.id
    else
      render json: params[:id]
    end
  end

  def create
    params[:id]=''
    params[:friend][:id] = ''
    @friend = Friend.create(friend_params)
    render json: @friend.id
  end

  def update
    @friend = Friend.find(params[:id])
    str=params[:img].split('/')
    str=str[str.length - 1]
    params[:img]=str
    params[:friend][:img]=str
    change_cycle(@friend, params)
    change_images(@friend, params)
    @friends = @friend.update_attributes(friend_params) if @friend
    render json: @friend.id
  end

  private

  def make_data_hash(curr_user)
    user = User.where(id: curr_user.id).select(:id,:email,:name,:gender,:status,:paid,:birthday,:cycle_day,:begin).first
    { user: user,
      language: locale,
      banned: BlackList.take_catalog(user),
      agents: Agent.take_catalog(user),
      froms: From.take_catalog(user),
      messages: Message.take_catalog(user),
      reasons: Reason.take_catalog(user),
      friends: user.take_data_structure
    }
  end

  def change_cycle(friend, params)
    if friend && params
      Event.put_cycle(friend,params[:cycle_day]) if friend.cycle_day != params[:cycle_day]
    end
  end

  def change_images(item,par)
    if item && par
      Image.change_image([item.img, par[:img]],par[:id]) if item.img!=par[:img] || par[:show]=='blocked'
    end
  end

  def friend_params
    params.require(:friend).permit(:user_id, :id, :name, :img, :cycle_day, :status, :show, :gender, events:[:id, :user, :friend_id,:reason_id, :begin_date,:period,:duration_day,:shift_day,:color, :status, letters:[:id, :user, :event_id,:agent_id, :from_id,:message_id,:status]], friend: [:id, :user_id, :name, :img, :cycle_day, :status,:gender])
  end

end
