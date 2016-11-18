class Api::V1::SuggestionTasksController < ApplicationController

  def create
    unless task_suggestion_params.blank?
      @describe = Describe.find_by_id(params[:describe_id])
      @task_suggestion = @describe.task_suggestions.build(task_suggestion_params)
      if @task_suggestion.valid?
        @task_suggestion.save
        render :json => {data: @task_suggestion.as_json(:include => [:user]), message: "Suggestion Task has been successfully created",:status => 200}
      else
        render json: {  message: "Fill the empty fields", :status => 422  }
      end
    end
  end

  def index
    if params[:describe_id].present?
      @describe = Describe.find_by_id(params[:describe_id])
      @task_suggestion = @describe.task_suggestions.where("suggestion_status = ?",false)
      render json: { data: @task_suggestion.as_json(:include => [:user,:likes,:needs])}, :status => 200
    else
      render json: { data: "project not present"}, :status => 200
    end
  end

  def profile_index
    @user = User.find_by_id(params[:id])
    @task_suggestion = @user.task_suggestions.all
    task_count = @task_suggestion.count
    render json: { data: task_count ,:status => 200 }
  end

  def update
    @describe = Describe.find_by_id(params[:describe_id])
    if @describe
      @task_suggestion = @describe.task_suggestions.find_by_id(params[:id])
      if @task_suggestion && !update_task_suggestion_params.blank?
        @task_suggestion.update_attributes(update_task_suggestion_params)
        if  @task_suggestion.save
          render json: { data:  @task_suggestion, message: "Suggestion Task has been updated successfully", :status => 200 }
        else
          render json: { error:  @task_suggestion.errors  }, :status => 422
        end
      else
        render json: { message: "Not updated"}, :status => 422
      end
    else
      render json: { message: "Suggestion Task not found"}, :status => 422
    end
  end

  def update_suggestion
    @task_suggestion = TaskSuggestion.find_by_id(params[:id])
    @task_suggestion.update_attribute('suggestion_status', true)
    if  @task_suggestion.save
      render json: { data:  @task_suggestion, message: "Suggestion Task has been updated successfully", :status => 200 }
    else
      render json: { message: "Not updated"}, :status => 422
    end
  end

  def destroy
    @task_suggestion = TaskSuggestion.find_by_id(params[:id])
    if @task_suggestion.present?
      if @task_suggestion.user_id == (current_user && current_user.id)
        @task_suggestion.destroy
        render :json => {data: @task_suggestion, :message => "Suggestion task_suggestion has been deleted successfully",  :status => 200}
      else
        render :json =>{message:"You are not authorized to delete this project",status:422}
      end
    else
      render :json => {data: @task_suggestion, :message => "Task Suggestion not found"},  :status => 422
    end
  end

  def like_tasksuggestion
    @task_suggestion = TaskSuggestion.find_by_id(params[:id])
    if params[:like] == true
      @current_user.like!(@task_suggestion)
      render :json => {message:"Like",:count=>@task_suggestion.likes.count, :status => 200}
    else
      @current_user.unlike!(@task_suggestion)
      render :json => {message:"Unlike",:count=>@task_suggestion.likes.count, :status => 200}
    end
  end

  private

  def task_suggestion_params
    params.permit(:suggestion_title, :describe_id, :date, :time, :venue, :description, :timezone, :suggestion_status).merge(user_id: @current_user.id)
  rescue
    {}
  end

  def update_task_suggestion_params
    params.permit(:describe_id, :date, :time, :venue, :description, :timezone, :suggestion_status).merge(user_id: @current_user.id)
  rescue
    {}
  end
end