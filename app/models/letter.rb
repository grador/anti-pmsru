class Letter < ActiveRecord::Base
  belongs_to :event
  belongs_to :from
  belongs_to :message
  has_many :histories, dependent: :destroy

  def self.make_today_list(events_list)
    where(event_id: events_list.map(&:id))
  end

  def self.send_notify_letters(letters)
    letters.each do |letter|
      FriendsMailer.notify_letter(letter).deliver_later
      History.create(user_id: letter.user, letter_id: letter.id, status: NOTIFY_MAIL_SENT)
    end
  end

end
