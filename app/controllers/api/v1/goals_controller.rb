class Api::V1::GoalsController < ApplicationController

  def index
    @describe = Describe.find(params[:describe_id])
    @goal = @describe.goals.all
    render json: { data: @goal}, :status => 200
  end

  def create
    unless goal_params.blank?
      @describe = Describe.find_by_id(params[:describe_id])
      @goal = @describe.goals.new(goal_params)
      if @goal.valid?
        @goal.save
        render json: {  message: "Successfully created", data: @goal }, :status => 200
      else
        render json: {  message: "Invalid goal", error: @goal.errors }, :status => 422
      end
    else
      render json: {  message: "Invalid Input"  }, :status => 422
    end
  end

  def reorder_goals
    params[:order].each do |value,key|
      Goal.find(value[:id]).update_attribute(:priority,value[:position])
    end
    render :json => {:status => 200}
  end

  def show
    @describe = Describe.find(params[:describe_id])
    @goal= @describe.goals.find_by_id(params[:id])
    if @goal
      render :json =>{message: "goal found",data: @goal,:status => 200}
    else
      render :json =>{message: "Invalid goal ID"},:status => 422
    end
  end

  def update
    @describe = Describe.find_by_id(params[:describe_id])
    if @describe
      @goal = @describe.goals.find_by_id(params[:id])
      if @goal && !goal_params.blank?
        if @goal.update_attributes(goal_params)
          render json: { data: @goal, message: "goal has been updated successfully", :status => 200 }
        else
          render json: { error: @goal.errors  }, :status => 422
        end
      else
        render json: { message: "Not updated"}, :status => 422
      end
    else
      render json: { message: "project not found"}, :status => 422
    end
  end


  def destroy
    @describe = Describe.find_by_id(params[:describe_id])
    if @describe
      @goal = @describe.goals.find_by_id(params[:id])
      if @goal && @goal.destroy
        render :json => {data: @goal, :message => "goal has been deleted successfully",  :status => 200}
      else
        render :json => {data: @goal, :message => " Sorry !could not delete the goal "},  :status => 422
      end
    else
      render json: { message: "project not found"}, :status => 422
    end
  end

  private

  def goal_params
    params.permit(:describe_id, :title, :priority)
  rescue
    {}
  end

end
