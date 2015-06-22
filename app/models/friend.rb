class Friend < ActiveRecord::Base
  validates :cycle_day, presence: true, on: :create

  belongs_to :user

  has_many :events, dependent: :destroy
  has_many :letters, through: :events
  accepts_nested_attributes_for :events, allow_destroy: true
  accepts_nested_attributes_for :events, update_only: true
  accepts_nested_attributes_for :letters, allow_destroy: true
  accepts_nested_attributes_for :letters, update_only: true
  accepts_nested_attributes_for :events, reject_if: lambda {
                                           |attributes| attributes['period'].blank? || attributes['begin_date'].nil?}

end
