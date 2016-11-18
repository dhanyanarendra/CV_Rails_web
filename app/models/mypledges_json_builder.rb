class MypledgesJsonBuilder
  def initialize(current_user)
    @current_user = current_user
    @response = {}
    @result = {}
  end

  def build_comment(pledge)
    @response = []
    pledge.each do |pledge|
      @response << build_mypledges(pledge)
    end
    @response
  end

  def build_mypledges(pledge)
    @need = Need.find pledge.need_id
    @result[:need_type] = @need.need_type
    @result[:need_name] = @need.need_name
    @result[:priority] = @need.priority
    @result[:need_id] = @need.id
    @result[:new_quantity] = @need.quantity
    @result[:date] = @need.task.date
    @result[:venue] = @need.task.venue
    @result[:task_id] = @need.task.id
    @result[:checked] = @need.checked
    @result[:pledged_count] = @need.pledges.where(user_contributor_id: @current_user.id).first.quantity
    @result[:need_item] = { id: @need.id,task_id: @need.task.id, pledge: @need.pledges, new_quantity: @need.quantity}
    @result[:title] = @need.task.goal.describe.title
    @result.as_json
  end
end
