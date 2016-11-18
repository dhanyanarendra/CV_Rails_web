class Api::V1::TasksController < ApplicationController

  def index
    @goals = Goal.find(params[:goal_id])
    @tasks = @goals.tasks.order("priority ASC")
    data = @tasks.as_json
    response = add_need_status(data)
    render json: { data: response}, :status => 200
  end

  def add_need_status(data)
    task_ids = Array.new

    data.each do |d|
      task_ids.push(d["id"])
    end
    need = Need.where("task_id IN (?)", task_ids)
    data.each do |d|
      d[:status]= false
      need.each do |n|
        if n["task_id"] == d["id"]
          d[:status]= true
        end
      end
    end

  end

  def create
    unless task_params.blank?
      @describe = Describe.find_by_id(params[:describe_id])
      @goal = @describe.goals.find_by_id(params[:goal_id])
      if @goal
        @task = @goal.tasks.new(task_params)
        if @task.valid?
          @task.save
          render :json => {data: @task, message: "Task has been successfully created",:status => 200}
        else
          render json: {  message: "Fill the empty fields", :status => 422  }
        end
      else
        render json: {  message: "Invalid Input" }, :status => 422
      end
    else
      render json: { message: "Goal not found"}, :status => 422
    end
  end

  def show
    @describe = Describe.find_by_id(params[:describe_id])
    @goal = @describe.goals.find_by_id(params[:goal_id])
    if @goal
      @task = @goal.tasks.find_by_id(params[:id])
      if @task
        if @task.task_suggestion_id.present?
          tasksuggestion = TaskSuggestion.find @task.task_suggestion_id
          like_count = tasksuggestion.likes.count
          user = User.find tasksuggestion.user_id
          user_name = user.user_name
        end
        render :json => {data: @task,like_count: like_count, user: user_name, message: "Task found", :status => 200}
      else
        render :json => {message: "task not found"} , :status =>422
      end
    else
      render :json => {message: "goal not found"} , :status =>422
    end
  end


  def update
    @goal = Goal.find_by_id(params[:goal_id])
    if @goal
      @task = @goal.tasks.find_by_id(params[:id])
      if @task && !task_params.blank?
        @task.update_attributes(task_params)
        if @task.save
          render json: { data: @task, message: "Task has been updated successfully", :status => 200 }
        else
          render json: { error: @task.errors  }, :status => 422
        end
      else
        render json: { message: "Not updated"}, :status => 422
      end
    else
      render json: { message: "Goal not found"}, :status => 422
    end
  end

  def destroy
    @goal = Goal.find_by_id(params[:goal_id])
    if @goal
      @task = @goal.tasks.find_by_id(params[:id])
      if @task && @task.destroy
        render :json => {data: @task, :message => "Task has been deleted successfully",  :status => 200}
      else
        render :json => {data: @task, :message => " Sorry !could not delete the task "},  :status => 422
      end
    else
      render json: { message: "Goal not found"}, :status => 422
    end
  end

  def reorder_tasks
    params[:order].each do |value,key|
      Task.find(value[:id]).update_attribute(:priority,value[:position])
    end
    render :json => {:status => 200}
  end

  private

  def task_params
    params.permit(:title, :goal_id, :priority, :task_suggestion_id, :like_count, :date, :time, :venue, :description, :timezone)
  rescue
    {}
  end
end
