class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :letter
  belongs_to :event

  def self.make_today_list
    where("created_at>?", Date.yesterday).where(status: [NOTIFY_MAIL_SENT,TRACE_MAIL_SENT])
  end
end
