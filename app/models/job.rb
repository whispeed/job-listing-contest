class Job < ApplicationRecord
  validates :title, presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_lower_bound, numericality: { greater_than: 0}

  scope :published, -> {where(is_hidden: false)}
  scope :recent, -> {order('created_at DESC')}

  has_many :resumes
  belongs_to :user
  has_many :favorites
  has_many :followers, through: :favorites, source: :user
end
