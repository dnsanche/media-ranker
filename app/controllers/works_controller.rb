class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update, :destroy]
  before_action :if_missing_work, only: [:show, :edit, :destroy]

  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params) 
    if @work.save
      redirect_to work_path(@work.id) 
      return
    else 
      render :new 
      return
    end
  end

  def show ; end
  
  def edit ; end
  
  def update    
    if @work.update(work_params)
      redirect_to work_path 
      return
    else 
      render :edit 
      return
    end
  end

  def destroy    
    @work.destroy
    redirect_to root_path
    return
  end
  
  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end

  def if_missing_work
    if @work.nil?
      flash[:error] = "Work with id #{params[:id]} was not found"
      redirect_to root_path 
      return
    end
  end
end