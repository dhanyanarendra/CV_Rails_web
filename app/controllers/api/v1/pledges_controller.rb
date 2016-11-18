class Api::V1::PledgesController < ApplicationController

  def pledge_need
    @task = Task.find_by_id(params[:task_id])
    need = @task.needs.find_by_id(params[:need_id])
    pledge(need) if params["pledge"][:pledged].present?
    unpledged(need) unless params["pledge"][:pledged].present?
  end

  def pledge(need)
    unless need.pledges.present? && need.pledges.map(&:user_contributor_id).include?(@current_user.id)
      pledge = need.pledges.build(pledge_params)
      pledge.save
      render :json => {data: pledge, :quantity_count=>need.pledges.map(&:quantity).sum(&:to_i), message: "Pledged", :status => 200}
    else
      unpledged(need)
    end
  end

  def unpledged(need)
    pledge = need.pledges.where(user_contributor_id: @current_user).first
    pledge.update_attributes(quantity: (pledge_params[:pledged] == true ? pledge_params[:quantity] : 0),pledged: pledge_params[:pledged])
    need.update_attributes(checked: false)  if need.checked?
    render :json => {data: pledge,:quantity_count=>quantity_count(need,pledge), :status =>200 }
  end

  def quantity_count(need, pledge)
    need.pledges.reload.map(&:quantity).sum(&:to_i)-(params["pledge"][:pledged].present? ? 0 : pledge.quantity.to_i)
  end

  def user_contributions
    @user = User.find_by_id(params[:id])
    @need = @user.pledges.where('pledged = ?', true)
    need_count = @need.count
    render json: { data: need_count ,:status => 200 }
  end

  def pledge_params
    params.require(:pledge).permit(:quantity, :pledged).merge(user_contributor_id: @current_user.id)
  rescue
    {}
  end
end