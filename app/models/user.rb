# require 'Sprockets'
# include Sprockets
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :timeoutable and :omniauthable , :lockable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :histories
  has_many :friends
  accepts_nested_attributes_for :friends, allow_destroy: true
  accepts_nested_attributes_for :friends, update_only: true
  accepts_nested_attributes_for :friends, reject_if: lambda {
                                          |attributes| attributes['name'].blank? || attributes['cycle_day'].nil?|| 0 == attributes['cycle_day']}
  def take_data_structure
    d = self.friends.where.not(status:DELETED_SAVED).select(:id,:user_id,:name,:img,:cycle_day,:status,:gender)
        .as_json(include:{events:{
                     include: {letters:{only:[:id,:user,:event_id,:agent,:from_id,:message_id,:status]}},
                     only:[:id,:user,:friend_id,:reason_id,:begin_date,:period,:duration_day,:shift_day,:color,:status]}})
    d.each do |f|
      f['img'] = Rails.env.production?? ActionController::Base.helpers.asset_path(f['img']) : 'assets/'+f['img']
    end
    d
  end
end
