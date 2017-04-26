class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :follow, :unfollow]
  before_action :validate_search_key, only: [:search]

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.order('wage_lower_bound DESC')
    when 'by_upper_bound'
      Job.published.order('wage_upper_bound DESC')
    else
      Job.published.recent
    end
  end

  # def new
  #   @job = Job.new
  # end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "该工作已被归档"
      redirect_to root_path
    end
  end

  # def create
  #   @job = Job.new(job_params)
  #
  #   if @job.save
  #     redirect_to jobs_path, notice: "新建成功！"
  #   else
  #     render :new
  #   end
  # end
  #
  # def edit
  #   @job = Job.find(params[:id])
  # end
  #
  # def update
  #   @job = Job.find(params[:id])
  #   if @job.update(job_params)
  #     redirect_to jobs_path, notice: "已更新！"
  #   else
  #     render :edit
  #   end
  # end
  #
  # def destroy
  #   @job = Job.find(params[:id])
  #   @job.destroy
  #   redirect_to jobs_path, alert: "已删除工作！"
  # end

  def follow
    @job = Job.find(params[:id])

    if !current_user.is_follower_of?(@job)
      current_user.follow!(@job)
      flash[:notice] = "已收藏工作"
    end

    redirect_to :back
  end

  def unfollow
    @job = Job.find(params[:id])

    if current_user.is_follower_of?(@job)
      current_user.unfollow!(@job)
      flash[:alert] = "收藏已取消"
    end

    redirect_to :back
  end

  def search
    if @query_string.present?
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.recent.paginate(:page => params[:page], :per_page => 5 )
    end
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :category, :location, :company)
  end

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  {
        title_or_company_or_location_cont: @query_string
      }
    end
  end

  def search_criteria(query_string)
    { :title_cont => query_string }
  end
end
