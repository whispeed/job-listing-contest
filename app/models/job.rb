# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  title            :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wage_upper_bound :integer
#  wage_lower_bound :integer
#  contact_email    :string
#  is_hidden        :boolean          default("t")
#  user_id          :integer
#  location         :string
#  category         :string
#  company          :string
#

class Job < ApplicationRecord
  validates :title, presence: { message: "请填写职位名称" }
  validates :wage_upper_bound, presence: { message: "请填写薪资上限" }
  validates :wage_lower_bound, presence: { message: "请填写薪资下限" }
  validates :wage_lower_bound, numericality: { greater_than: 0, message: "薪资下限必须大于零" }
  validates :wage_lower_bound, numericality: { less_than: :wage_upper_bound, message: "薪资下限不能高于薪资上限" }
  validates :location, presence: { message: "请选择工作地点" }
  validates :category, presence: { message: "请选择工作种类" }
  validates :contact_email, presence: { message: "请填写联系用邮箱" }
  validates_format_of :contact_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i , message: "请输入正确的邮箱格式"


  scope :published, -> {where(is_hidden: false)}
  scope :recent, -> {order('created_at DESC')}

  has_many :resumes
  belongs_to :user
  has_many :favorites
  has_many :followers, through: :favorites, source: :user
  has_many :applicant, through: :resumes, source: :user
end
