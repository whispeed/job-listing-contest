class Account::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      current_user.favorited_jobs.order('wage_lower_bound DESC')
    when 'by_upper_bound'
      current_user.favorited_jobs.order('wage_upper_bound DESC')
    else
      current_user.favorited_jobs.recent
    end
  end
end
