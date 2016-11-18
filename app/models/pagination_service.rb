class PaginationService

  def initialize(current_page, total_cards)
    @current_page = current_page
    @total_cards = total_cards
  end

  def build_pagination()
    result_hash = {}
    result_hash[:current_page] = @current_page
    result_hash[:total_cards] = @total_cards
    result_hash
  end

end
