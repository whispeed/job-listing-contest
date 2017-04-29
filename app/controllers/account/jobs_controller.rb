class Account::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      current_user.favorited_jobs.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 5)
    when 'by_upper_bound'
      current_user.favorited_jobs.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 5)
    else
      current_user.favorited_jobs.recent.paginate(:page => params[:page], :per_page => 5)
    end
  end
end
