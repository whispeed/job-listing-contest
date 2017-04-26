class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :follow, :unfollow]
  before_action :validate_search_key, only: [:search]

  def index
    if params[:location].present?
      @location = params[:location]
      @jobs = case params[:order]
      when 'by_lower_bound'
        Job.where(:is_hidden => false, :location => @location).order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 10)
      when 'by_upper_bound'
        Job.where(:is_hidden => false, :location => @location).order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 10)
      else
        Job.where(:is_hidden => false, :location => @location).recent.paginate(:page => params[:page], :per_page => 10)
      end

    elsif params[:category].present?
      @category = params[:category]
      @jobs = case params[:order]
      when 'by_lower_bound'
        Job.where(:is_hidden => false, :category => @category).order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 10)
      when 'by_upper_bound'
        Job.where(:is_hidden => false, :category => @category).order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 10)
      else
        Job.where(:is_hidden => false, :category => @category).recent.paginate(:page => params[:page], :per_page => 10)
      end

    else
      @jobs = case params[:order]
      when 'by_lower_bound'
        Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 10)
      when 'by_upper_bound'
        Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 10)
      else
        Job.published.recent.paginate(:page => params[:page], :per_page => 10)
      end
    end
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "该工作暂未公开"
      redirect_to root_path
    end
  end

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

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  search_criteria(@query_string)
    end
  end

  def search_criteria(query_string)
    { :title_or_description_or_location_or_category_or_company_cont => query_string }
  end
end
