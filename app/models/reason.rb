class Reason < ActiveRecord::Base
  has_many :events
  def self.take_catalog(user)
    where({ user: [user.id, 0]}).select(:id,:user,:name,:period,:duration_day,:status,:language).order('user DESC').as_json
  end
end
