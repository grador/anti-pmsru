class HardWorker
  include Sidekiq::Worker

  def perform
    Image.clean_up_image
    check_free_user_ip
    users =User.all.map(&:id)
    clean_up_leafs(users)
    clean_up_friends(users)
    background_mailer
  end

  def clean_up_leafs(users)
    %w(Agent From Message Reason).each do |i|
      garbage = eval(i).where(user: users, status: BLOCKED_SAVED).where("updated_at<?",3.month.ago)
      eval(i).delete(garbage.map(&:id)) if garbage.length >0
    end
  end

  def clean_up_friends(users)
    %w(Friend Event Letter).each do |i|
      garbage = eval(i).where(user: users, status: DELETED_SAVED).where("updated_at<?",Time.now)
      eval(i).destroy(garbage.map(&:id)) if garbage.length >0
    end
  end

  def background_mailer
    events_list = Event.make_list
    unless events_list.blank?
      today_history = History.make_today_list
      letters_list = Letter.make_today_list(events_list)
      not_sent_letters = make_not_send_letter_list(letters_list,today_history)
      Letter.send_notify_letters(not_sent_letters) unless not_sent_letters.blank?
      trace_events_list = make_trace_events_list(events_list,letters_list,today_history)
      send_trace_letters(trace_events_list) unless trace_events_list.blank?
    end
    #   TODO написать расчет циклов для наблюдений за объектом
  end

  def send_trace_letters(events)
    events.each do |event|
      FriendsMailer.trace_letter(event).deliver_later
      History.create(user_id: event.user, event_id: event.id, status: TRACE_MAIL_SENT)
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
          FriendsMailer.ban_letter(user).deliver_later
          History.create(user_id: user.id, status: BAN_MAIL_SENT)
          BlackList.create(user: user.id, email: user.email, name:user.name, ip: user.current_sign_in_ip)
        end
      end
    end
  end

end