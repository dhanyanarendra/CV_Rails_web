class FormatProjectsResponse
  def self.format(user_id)
    response = []
    projects = Describe.where("user_originator_id=?", user_id)
    projects.each do |project|
      response << format_project(project)
    end
    response
  end

  private
  def self.format_project(project)
    {
      id: project.id,
      title: project.title,
      category: project.category,
      short_description: project.short_description,
      image: project.file.url,
      published: project.published
    }
  end
end
