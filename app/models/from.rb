class From < ActiveRecord::Base
  has_many :letters
  def self.take_catalog(user)
    where({ user: [user.id, 0]}).select(:id,:user,:email,:status,:name,:language).order('user DESC').as_json
  end

end
