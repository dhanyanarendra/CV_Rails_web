class Api::V1::DescribesController < ApplicationController

  def index
    if params[:category].present?
      @describe = Describe.where("category = ? AND published = ?", params[:category], true)
    else
      @describe = Describe.where('published = ?', true)
    end
    render :json => {message:"List of projects",data: @describe.as_json(:user_like => current_user,:user_follow => current_user,:include => [:likes,:follows]), :status => 200}
  end

 def search
    describe = Describe.all
    if params[:query]
      title = params[:query]["title"].strip
      category = params[:query]["category"].strip
      if params[:query]["category"] == "All Categories"
        describe = Describe.where("title ILIKE ('%#{title}%')")
      else
        describe = Describe.where("title ILIKE ('%#{title}%') AND category ILIKE ('%#{category}%')")
      end
      render :json => {message: "search found",data: describe},:status => 200
    else
      render :json => {message: "search not found",data: {}},:status => 404
    end
  end

  def pledged_user
    @need = Need.find_by_id(params[:need_id])
    if @need.present?
    @pledges = @need.pledges.where('pledged = ?', true)
      render :json => {message:"List of pledged users",data: PledgeJsonBuilder.new(@pledges,@current_user).build_pledge, :status => 200}
    else
      render :json => {message: "No Pledged user found",data: []},:status => 422
    end
  end

  def list
    if current_user
      projects_list = FormatProjectsResponse.format(current_user.id)
      render :json => {message:"Successfully listed projects",data: projects_list ,status:200}
    end
  end

  def dashboard_projects
    if current_user
      projects_list = current_user.describes.all
      render :json => { message: "Projects list",
        data: projects_list.as_json(:include => {:goals => {:include => {:tasks => {:include => {:needs => {:include => :pledges}}}} } }),
        status: 200
      }
    end
  end

  def my_pledges
    if current_user
      @pledges = current_user.pledges.where(pledged: true)
      if @pledges.present?
        render :json => {:success=>true, message: "Pledges list",data: MypledgesJsonBuilder.new(current_user).build_comment(@pledges),
          status: 200
        }
      else
        render :json => {:success=>false, message: "No Pledges found",data: [],
          status: 200
        }
      end
    end
  end

  def fetch_project_details
    if current_user
      project = Describe.find_by_id(params[:describe_id])
      render :json => { message: "Successfully listed all the details of the projects",
        data: project.as_json(:include => {:goals => {:include => {:tasks => {:include => {:needs => {:include => :pledges}}}} } }),
        status: 200
      }
    end
  end

  def destroy
    describe = Describe.where('id = ?', params[:id]).first
    if describe.present?
      if describe.user_originator_id == (current_user && current_user.id)
        describe.destroy
        describe.user.pledges.destroy if describe.user.pledges.present?
        render :json =>{message:"Successfully deleted project",status:200}
      else
        render :json =>{message:"You are not authorized to delete this project",status:422}
      end
    else
      render :json =>{message:"Invalid project ID"},status:422
    end
  end


  def like_project
    @describe = Describe.find_by_id(params[:id])
    if params[:like] == true
      @current_user.like!(@describe)
      render :json => {message:"Like",:count=>@describe.likes.count, :status => 200}
    else
      @current_user.unlike!(@describe)
      render :json => {message:"Unlike",:count=>@describe.likes.count, :status => 200}
    end
  end


  def follow_project
    @describe = Describe.find_by_id(params[:id])
    if params[:follow] == true
      @current_user.follow!(@describe)
      render :json => {message:"Follow",:follow_count=>@describe.follows.count, :status => 200}
    else
      @current_user.unfollow!(@describe)
      render :json => {message:"Unfollow",:follow_count=>@describe.follows.count, :status => 200}
    end
  end


  def publish
    @describe = Describe.find_by_id(params[:id])
    begin
      @describe.update_attributes(:published => params[:published])
      render :json =>{message: "Project Published",data: @describe,:status => 200}
    rescue
      render :json =>{message: "Project Not Published"},:status => 422
    end
  end

  def show
    @describe = Describe.find_by_id(params[:id])
    if @describe
      render :json => { message: "Project found",
        data: @describe.as_json(:include => {:goals => {:include => {:tasks => {:include => :needs}} } }),
        count: @describe.likes.count,
        follow_count: @describe.follows.count,
        like: @current_user.likes?(@describe),
        follow: @current_user.follows?(@describe),
        originator_name: @describe.user.user_name ,
        status: 200
      }
    else
      render :json =>{message: "Invalid project ID"},:status => 422
    end
  end

  def update
    @describe = Describe.find_by_id(params[:id])
    if @describe && !describe_params.blank?
      if @describe.update_attributes(describe_params)
        render json: { data: @describe, message: "Project has been updated successfully", :status => 200 }
      else
        render json: { error: @describe.errors , message: "Please fill the empty fields" }, :status => 422
      end
    else
      render json: { message: "Project not found"}, :status => 422
    end
  end


  def user_publish
    @user = User.find_by_id(params[:id])
    @publish_projects = @user.describes.where('published = ?', true).all
    @publish_projects_count = @publish_projects.count
    render json: { data: @publish_projects_count, project_title: @publish_projects, :status => 200 }
  end


  def create
    if params[:describe].present?
      @describe =Describe.new(describe_params)
      if current_user.present?
        @describe.user_originator_id = current_user.id
      end
      if @describe.save
        session[:describe_id] = @describe.id
        render :json => {message:"Successfully created describes",data: @describe,:status => 200}
      else
        render :json => {message:"Invalid entry",errors: @describe.errors,:status => 401}
      end
    else
      render json: {  message: "Fill the empty fields" }, :status => 422
    end
  end

  def show_all_followed_projects
    if current_user.present?
      projects_list = Describe.all
      projects_length = projects_list.length
      counter = 0;
      describe_list = []  # Array which contains list of projects where user has followed.

      projects_length.times do |n|  # Iterates over all the projects.
        if projects_list[n].follows.present?
          follower_list = projects_list[n].follows.all
          followers_length = follower_list.length

            followers_length.times do |m|  # Iterates over all the followers for a particular project.
              if current_user.id == follower_list[m].follower_id
                describe_list << projects_list[n]
              end
            end
        end
      end
      render :json => { message: "Successfully listed all the projects followed by the current user.",data:  describe_list,status: 200 }

    else
      render :json => { message: "User not found."},status: 422
    end
  end

private

def describe_params
  the_params = params.require(:describe).permit(:title, :name, :category, :short_description, :background, :impact, :need, :risks, :user_originator_id, :published, :others, :file => [:data])
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

