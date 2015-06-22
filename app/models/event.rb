class Event < ActiveRecord::Base
  belongs_to :friend
  belongs_to :reason
  has_many :letters, dependent: :destroy
  accepts_nested_attributes_for :letters, allow_destroy: true
  accepts_nested_attributes_for :letters, update_only: true

  def self.put_cycle(friend,cycle_day)
    where(friend_id: friend.id).each do |e|
        e.update_column(:color,cycle_day)
    end
  end

  def self.make_list
    list=[]
    where.not(user: BlackList.all.map(&:user)).each do |event|
      list.push(event) if day_to_mail?(event)
    end
    list
  end
end

