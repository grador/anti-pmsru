class Agent < ActiveRecord::Base

  def self.take_catalog(user)
    where({ user: [user.id, 0], img: CONFIRMED}).select(:id,:user,:name,:email,:img,:status,:language).order('user DESC').as_json
  end

  def send_confirmation
    User.create(email: self.email, status:self.id, name: WAIT_CONFIRM).send_confirmation_instructions
    self
  end
end



