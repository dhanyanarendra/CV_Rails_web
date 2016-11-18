class PledgeJsonBuilder
  def initialize(pledges,user)
    @user = user
    @pledges = pledges
    @response = {}
    @result = {}
  end

  def build_pledge
    @response = []
    @pledges.each do |pledge|
      @response << build_pledges(pledge)
    end
    @response
  end

  def build_pledges(pledge) 
    @result = pledge.user.as_json
    @need = Need.find pledge.need_id
    @result[:pledgeed_name] = pledge.user.user_name if pledge.user.present?
    @result[:pledgeed_image] = pledge.user.file if pledge.user.present?
    @result[:need_type] = @need.need_type
    @result[:need_name] = @need.need_name
    @result[:priority] = @need.priority
    @result[:need_id] = @need.id
    @result[:new_quantity] = @need.quantity
    @result[:task_id] = @need.task.id
    @result[:pledged_count] = @need.pledges.where(user_contributor_id: @user.id).first.quantity if @need.pledges.where(user_contributor_id: @user.id).present?
    @result[:need_item] = { id: @need.id,task_id: @need.task.id, pledge: @need.pledges, new_quantity: @need.quantity}
    @result.as_json
  end
end