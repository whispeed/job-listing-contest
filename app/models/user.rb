class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :resumes
  has_many :jobs
  has_many :favorites
  has_many :favorited_jobs, :through => :favorites, :source => :job

  def is_follower_of?(job)
    favorited_jobs.include?(job)
  end

  def admin?
    is_admin
  end

  def follow!(job)
    favorited_jobs << job
  end

  def unfollow!(job)
    favorited_jobs.delete(job)
  end
end
