class Api::V1::NeedsController < ApplicationController

  def index
    @tasks = Task.find(params[:task_id])
    @needs = @tasks.needs.all
    render json: { data: NeedJsonBuilder.new(@needs,@current_user).build_need}, :status => 200
  end

  def checked_needs
    @need = Need.find_by_id(params[:id]) if params[:id].present?
    if @need.present?
      @need.update_attributes(checked: params[:checked])
      render json: {data: @need }, :status => 200
    else
      render json: {message: "Needs not checked" }, :status => 404
    end
  end

  def create
    unless need_params.blank?
      @task = Task.find(params[:task_id])
      @need = @task.needs.new(need_params)
      if @task
        if @need.valid? && @need.save
          render :json => {data: @need, message: "Need has been successfully created",:status => 200}
        else
          render json: {  message: "Fill the empty fields", :status => 422  }
        end
      else
        render json: {  message: "Invalid Input" }, :status => 422
      end
    else
      render json: { message: "Task not found"}, :status => 422
    end
  end


  def suggestion_need
    unless need_params.blank?
      @task_suggestion = TaskSuggestion.find(params[:id])
      @need = @task_suggestion.needs.new(need_params)
      if @task_suggestion
        if @need.valid? && @need.save
          render :json => {data: @need, message: "Suggestion Need has been successfully created",:status => 200}
        else
          render json: {  message: "Fill the empty fields", :status => 422  }
        end
      else
        render json: {  message: "Invalid Input" }, :status => 422
      end
    else
      render json: { message: "Suggestion Task not found"}, :status => 422
    end
  end

  def suggestion_need_update
    @task_suggestion = TaskSuggestion.find(params[:task_suggestion_id])
    if @task_suggestion
      @need = @task_suggestion.needs.find_by_id(params[:id])
      if @need && !need_params.blank?
        @need.update_attributes(need_params)
        if  @need.save
          render json: { data:  @need, message: "Suggestion Need has been updated successfully", :status => 200 }
        else
          render json: { error:  @need.errors  }, :status => 422
        end
      else
        render json: { message: "Not updated"}, :status => 422
      end
    else
      render json: { message: "Suggestion Need not found"}, :status => 422
    end
  end


  def suggestion_index
    @task_suggestion = TaskSuggestion.find(params[:id])
    @need = @task_suggestion.needs.all
    render json: { data: @need}, :status => 200
  end

  def suggestion_destroy
    @task_suggestion = TaskSuggestion.find_by_id(params[:task_suggestion_id])
    if @task_suggestion
      @need = @task_suggestion.needs.find_by_id(params[:id])
      if @need && @need.destroy
        render :json => {data: @need, :message => " Suggestion Need has been deleted successfully",  :status => 200}
      else
        render :json => {data: @need, :message => " Sorry !could not delete the  Suggestion Need "},  :status => 422
      end
    else
      render json: { message: " Suggestion Task not found"}, :status => 422
    end
  end

  def show
    @describe = Describe.find_by_id(params[:describe_id])
    @goal = @describe.goals.find_by_id(params[:goal_id])
    if @goal
      @task = @goal.tasks.find_by_id(params[:task_id])
      if @task
        @need = @task.needs.find_by_id(params[:id])
        if @need
          render :json => {data: @need, message: "need found", :status => 200}
        else
          render :json => {message: "need not found"} , :status =>422
        end
      else
        render :json => {message: "task not found"} , :status =>422
      end
    else
      render :json => {message: "goal not found"} , :status =>422
    end
  end


  def update
    @task = Task.find_by_id(params[:task_id])
    if @task
      @need = @task.needs.find_by_id(params[:id])
      if @need && !need_params.blank?
        @need.update_attributes(need_params)
        if @need.save
          render json: { data: @need, message: "Need has been updated successfully", :status => 200 }
        else
          render json: { error: @need.errors  }, :status => 422
        end
      else
        render json: { message: "Not updated"}, :status => 422
      end
    else
      render json: { message: "Task not found"}, :status => 422
    end
  end

  def destroy
    @task = Task.find_by_id(params[:task_id])
    if @task
      @need = @task.needs.find_by_id(params[:id])
      if @need && @need.destroy
        render :json => {data: @need, :message => "Need has been deleted successfully",  :status => 200}
      else
        render :json => {data: @need, :message => " Sorry !could not delete the Need "},  :status => 422
      end
    else
      render json: { message: "Task not found"}, :status => 422
    end
  end

  def project_needs
    @describe=Describe.find_by_id(params[:describe_id])
    render json: { data: ProjectNeedJsonBuilder.new(@describe,@current_user).build_project_needs}, :status => 200
  end

  private

  def need_params
    params.permit(:task_id, :need_name, :priority, :need_type, :quantity, :new_quantity, :unit, :need_decription, :task_suggestion_id, :checked)
  rescue
    {}
  end

end
