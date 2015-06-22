include PublicMethods
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  respond_to :json
  rescue_from ActionController::RoutingError, :with => :go_to_root
  rescue_from ActionController::BadRequest, :with => :go_to_root
  rescue_from ActionController::RenderError, :with => :go_to_root
  rescue_from ActionController::MethodNotAllowed, :with => :go_to_root
  rescue_from ActionController::InvalidAuthenticityToken, :with => :go_to_root
  rescue_from ActionController::UnknownFormat, :with => :go_to_root
  rescue_from ActiveRecord::RecordNotFound, :with => :go_to_root
  rescue_from ActiveRecord::RecordNotSaved, :with => :go_to_root


  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?


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

  def clean_up_leafs
    Image.clean_up_image
    user = current_user
    %w(Agent From Message Reason).each do |i|
      garbage = eval(i).where(user: user, status: BLOCKED_SAVED).where("updated_at<?",3.month.ago)
      eval(i).delete(garbage.map(&:id)) if garbage.length >0
    end
  end

  def clean_up_friends
    user = current_user
    %w(Friend Event Letter).each do |i|
      garbage = eval(i).where(user: user, status: DELETED_SAVED).where("updated_at<?",Time.now)
      eval(i).destroy(garbage.map(&:id)) if garbage.length >0
    end
  end

  def send_trace_letters(events)
    events.each do |event|
      FriendsMailer.trace_letter(event).deliver_now
      History.create(user_id: event.user, event_id: event.id, status: TRACE_MAIL_SENT)
    end
  end

  def send_notify_letters(letters)
     letters.each do |letter|
       FriendsMailer.notify_letter(letter).deliver_now
       History.create(user_id: letter.user, letter_id: letter.id, status: NOTIFY_MAIL_SENT)
     end
  end

  def check_agents_confirmation
    User.where(name: WAIT_CONFIRM).each do |u|
      if u.confirmed?
        Agent.update(u.status,img:CONFIRMED) && u.delete
      else
        if u.confirmation_sent_at < 2.days.ago
          Agent.find(u.status).delete
          u.delete
        end
      end
    end
  end

  def make_trace_events_list(events, letters,history)
    trace_list = events.map(&:id) - letters.uniq(&:event_id).map(&:event_id)
    trace_list = trace_list - history.map(&:event_id)
    events.select{|e| !([e.id] & trace_list).blank?}
  end

  def make_not_send_letter_list(letters,history)
    send_list = letters.map(&:id) - history.map(&:letter_id)
    letters.select{|l| !([l.id] & send_list).blank?}
  end

  def check_free_user_ip
    user_list = User.where(paid: nil).where.not(id: BlackList.all.map(&:user)).order(:created_at)
    uniq_id_user_list = user_list.to_a.uniq(&:current_sign_in_ip).map(&:id)
    if user_list.length > uniq_id_user_list.length
      repeat_id_user_list = user_list.map(&:id) - uniq_id_user_list
      repeat_user_list = user_list.select{|user| !([user.id] & repeat_id_user_list).blank?}
      id_banned_users = BlackList.where(user: repeat_user_list.map(&:id)).map(&:user)
      repeat_user_list.each do |user|
        if (id_banned_users & [user.id]).empty?
          FriendsMailer.ban_letter(user).deliver_now
          History.create(user_id: user.id, status: BAN_MAIL_SENT)
          BlackList.create(user: user.id, email: user.email, name:user.name, ip: user.current_sign_in_ip)
        end
      end
    end
  end

  def my_daemon
    events_list = Event.make_list
    unless events_list.blank?
      today_history = History.make_today_list
      letters_list = Letter.make_today_list(events_list)
      not_sent_letters = make_not_send_letter_list(letters_list,today_history)
      send_notify_letters(not_sent_letters) unless not_sent_letters.blank?
      trace_events_list = make_trace_events_list(events_list,letters_list,today_history)
      send_trace_letters(trace_events_list) unless trace_events_list.blank?
    end
    # TODO поставить второй раз в aplication_controller
    check_agents_confirmation
    check_free_user_ip

  #   TODO расчет циклов для наблюдений
  # TODO при подтверждении адреса для посторонней отправки при подтверждении идет редирект в систему посмотреть и сделать как надо
  end
  def go_to_root
    redirect_to root_url
  end
  def check_auth
    redirect_to root_url unless user_signed_in?
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email,:name,:password,:password_confirmation,:gender, :status, :paid,:birthday,:cycle_day,:begin) }
  end

end
