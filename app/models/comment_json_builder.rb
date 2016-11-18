class CommentJsonBuilder
  def initialize(comment,user)
      @user = user
      @comments = comment
      @response = {}
      @result = {}
  end

  def build_comment
    @response = []
    @comments.each do |comment|
      @response << build_comments(comment)
    end
    @response
  end

  def build_comments(comment)
    @result = comment.as_json
    @result[:commented_name] = comment.user.user_name if comment.user.present?
    @result[:commented_image] = comment.user.file if comment.user.present?
    @result
  end
end
