class NeedJsonBuilder
	def initialize(need,user)
      @user = user
      @need = need
      @response = {}
      @result = {}
	end

	def build_need
		@response = []
		@need.each do |need|
      @response << build_pledges(need)
		end
		@response
	end

	def build_pledges(need)
		@result = need.as_json
		@result[:pledge] = need.pledges.where(user_contributor_id:  @user.id) if @user.present?
		@result[:total] = need.pledges.map(&:quantity).sum(&:to_i) if @user.present?
		@result
	end

end
