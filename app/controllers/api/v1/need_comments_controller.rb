class Api::V1::NeedCommentsController < ApplicationController

  def index
    @need = Need.find_by_id(params[:need_id])
    if @need
      @need_comments = @need.need_comments
      render :json => {message:"List of comments",data: CommentJsonBuilder.new(@need_comments,@current_user).build_comment, :status => 200}
    else
      render json: { message: "Need not found"}, :status => 404
   end
 end


  def create
    unless need_comment_params.blank?
      @need = Need.find_by_id(params[:need_id])
      @need_comments = @need.need_comments.build(need_comment_params)
      @need_comments.user_id = params[:user_id]
      if @need_comments.valid? && @need_comments.save
        render json: {  message: "Successfully created need comment", data: @need_comments}, :status => 200
      else
        render json: {  message: "Invalid need comment", error: @need_comments.errors }, :status => 422
      end
    else
      render json: {  message: "Invalid Input"  }, :status => 404
    end

  end

  def destroy
    @need = Need.find_by_id(params[:need_id])
    if @need
      @need_comment = NeedComment.find_by_id(params[:id])
      if  @need_comment &&  @need_comment.destroy
        render :json => {data:  @need_comment, :message => " Need Comment has been deleted successfully",  :status => 200}
      else
        render :json => {data:  @need_comment, :message => " Sorry !could not delete the need comment "},  :status => 422
      end
    else
      render json: { message: "Need not found"}, :status => 404
    end

  end


  private

  def need_comment_params
    the_params =  params.require(:need_comment).permit(:body_description, :user_id, :need_id)

  end
end