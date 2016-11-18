class ProjectNeedJsonBuilder
  def initialize(describe,user)
    @describe= describe
    @user= user
    @response = {}
    @result={}
  end

  def build_project_needs
    @response = []
    @describe.goals.each do |goal|
      goal.tasks.each do |task|
        task.needs.each do |need|
          @response << build_needs(need)
        end
      end
    end
    @response
  end

  def build_needs(need)
    @result[:id] = need.id
    @result[:need_name] = need.need_name
    @result[:need_type] = need.need_type
    @result[:priority] = need.priority
    @result[:quantity] = need.quantity
    @result[:task_id] = need.task.id
    @result[:new_quantity] = need.pledges.where(user_contributor_id: @user.id).first.quantity rescue nil
    @result[:total_quantity] = need.pledges.map(&:quantity).map(&:to_i).reduce(0, :+) 
    @result[:user_pledged] =  need.pledges.where("user_contributor_id=(?) AND pledged=(?)", @user.id, true).present? ? false : true 
    @result.as_json
  end
end
