class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true

  validates :email, presence: true
  validates :email, uniqueness: :true
  validates :email, format: { with: /.+@.+\..+/,
    message: "only allows letters" }

  mount_uploader :filepath, Uploader

  has_many :created_surveys, class_name: 'Survey', foreign_key: :creator_id
  has_many :participations, foreign_key: :taker_id
  has_many :taken_surveys, through: :participations, source: :survey
  has_many :answers, through: :participations

end
