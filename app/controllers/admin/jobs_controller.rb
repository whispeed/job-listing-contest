class Admin::JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_is_admin
  layout "admin"

  def index
    @jobs = current_user.jobs
  end

  def new
    @job = Job.new
  end

  def show
    find_job_and_check_permission
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user
    @job.company = current_user.name

    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    find_job_and_check_permission
  end

  def update
    find_job_and_check_permission
    if @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  def destroy
    find_job_and_check_permission
    @job.destroy
    redirect_to admin_jobs_path, alert: "已删除工作！"
  end

  def publish
    find_job_and_check_permission
    @job.is_hidden = false
    @job.save
    redirect_to :back
  end

  def hide
    find_job_and_check_permission
    @job.is_hidden = true
    @job.save
    redirect_to :back
  end

  private

  def find_job_and_check_permission
    @job = Job.find(params[:id])

    if current_user != @job.user
      redirect_to root_path, alert: "你没有权限！"
    end
  end

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :category, :location, :company)
  end

end
