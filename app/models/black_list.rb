class BlackList < ActiveRecord::Base

  def self.take_catalog(user)
  where(user: user.id).select(:id,:user,:name,:email,:ip,:flag,:status,:created_at).first.as_json
  end


end
