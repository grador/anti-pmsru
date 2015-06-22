class Letter < ActiveRecord::Base
  belongs_to :event
  belongs_to :from
  belongs_to :message
  has_many :histories, dependent: :destroy

  def self.make_today_list(events_list)
    where(event_id: events_list.map(&:id))
  end

end
