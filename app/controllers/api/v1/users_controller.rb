class Api::V1::UsersController < ApplicationController

  def create
    unless user_params.blank?
      @user =User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        render :json => {message:"Successfully created user",data: @user,:status => 200}
      else
        render :json => {message:"Invalid entry",errors: @user.errors,:status => 401}
      end
    else
      render json: {  message: "Fill the empty fields", :status => 422  }
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user && !user_params.blank?
      if @user.update_attributes(user_params)
        render json: { data: @user, message: "Successfully updated user", :status => 200 }
      else
        render json: { error: @user.errors , message: "Please fill the empty fields" }, :status => 422
      end
    else
      render json: { message: "User not found"}, :status => 422
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user
      @follow = @current_user.followees(User).count
      render json:{data: @user, follow_user: @user.follows.count,:following=>@follow, message:"Successfully listed user", :status => 200}
    else
      render json:{ message:"Invalid user ID"}, :status => 422
    end
  end

  def remove_profile_image
    @user = User.find_by_id(params[:id])
    if @user
     @user.remove_file!
     @user.name = ""
     @user.save
     render json:{data: @user, message: "Successfully removed user's profile image", :status => 200}
   else
    render json:{message: "Invalid user ID"} , :status => 422
  end
end

   def follow_user
  @user = User.find_by_id(params[:id])
  if params["follow"] == true
    user_follow = @current_user.follow!(@user)
    @follow = @current_user.followees(User).count
    render :json => {message:"Follow",:follow_count_user=>@user.follows.count,:following=>@follow, :status => 200}
  else
    user_unfollow = @current_user.unfollow!(@user)
    @unfollow = @current_user.followees(User).count
    render :json => {message:"Unfollow",:follow_count_user=>@user.follows.count,:following=>@unfollow,:status => 200}
  end
end


private

def user_params
  params[:websites] ||= []
  params[:interests] ||= []
  the_params= params.permit(:user_name,:email,:password,:first_name,:last_name,:phone_number,:company,:location,:timezone,:about_me,:name,:file => [:data],websites: [],interests: [])
  the_params[:file] = parse_image_data(the_params[:name],the_params[:file]) if (the_params[:file].present? && the_params[:file][:data].present?)
  the_params
end

def parse_image_data(file_name, base64_file)
  filename = file_name.present? ? file_name.gsub(/[()]/, '').gsub(' ','_').strip : ""
  @tempfile = Tempfile.new(filename)
  @tempfile.binmode
      # file = File.read Rails.root.join("spec", "fixtures", "download.jpg")
      # b = Base64.encode64(file.to_s)
      @tempfile.write Base64.decode64(base64_file["data"]) if base64_file["data"].present?
      # @tempfile.write Base64.decode64(b) if base64_file["data"].present?
      @tempfile.rewind
      # for security we want the actual content type, not just what was passed in
      content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]
      # we will also add the extension ourselves based on the above
      # if it's not gif/jpeg/png/pdf, it will fail the validation in the upload model
      extension = content_type.match(/gif|jpeg|png|jpg|tiff|bmp/).to_s

      if extension.present?
        filename = File.basename( filename, ".*" )
        filename += ".#{extension}"

        ActionDispatch::Http::UploadedFile.new({
          tempfile: @tempfile,
          content_type: content_type,
          filename: filename
          })
      else
        render :json => {message: "Invalid image format"}, :status => 422
      end
    end


    def clean_tempfile
      if @tempfile
        @tempfile.close
        @tempfile.unlink
      end
    end

  end