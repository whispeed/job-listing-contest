class Account::ResumesController < ApplicationController
  before_action :authenticate_user!

  def index
    @resumes = current_user.resumes.paginate(:page => params[:page], :per_page => 5)
  end
end
