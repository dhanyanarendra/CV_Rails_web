class Api::V1::CommentsController < ApplicationController

  def index
    @describe = Describe.find_by_id(params[:describe_id])
    @comments = @describe.comments
    render :json => {message:"List of comments",data: CommentJsonBuilder.new(@comments,@current_user).build_comment, :status => 200}
  end

  def create
    unless comment_params.blank?
      @describe = Describe.find_by_id(params[:describe_id])
      @comments = @describe.comments.build(comment_params)
      @comments.user_id = params[:user_id]
      if @comments.valid? && @comments.save
        render json: {  message: "Successfully created comment", data: @comments}, :status => 200
      else
        render json: {  message: "Invalid comment", error: @comments.errors }, :status => 422
      end
    else
      render json: {  message: "Invalid Input"  }, :status => 404
    end
  end

  def update
    @describe = Describe.find_by_id(params[:describe_id])
    if @describe
      @comment = Comment.find_by_id(params[:id])
      if @comment && !comment_params.blank?
        if @comment.update_attributes(comment_params)
          render json: { data: @comment, message: "Successfully updated comment", :status => 200 }
        else
          render json: { error: @comment.errors , message: "Please fill the empty fields" }, :status => 422
        end
      else
        render json: { message: "Comment not found"}, :status => 404
      end
    else
      render json: { message: "Describe not found"}, :status => 404
    end
  end

  def destroy
    @describe = Describe.find_by_id(params[:describe_id])
    if @describe
      @comment = Comment.find_by_id(params[:id])
      if @comment && @comment.destroy
        render :json => {data: @comment, :message => "Comment has been deleted successfully",  :status => 200}
      else
        render :json => {data: @comment, :message => " Sorry !could not delete the comment "},  :status => 422
      end
    else
      render json: { message: "Describe not found"}, :status => 404
    end

  end

  private

  def comment_params
    the_params = params.require(:comment).permit(:comment_body, :user_id, :describe_id)
  end


end