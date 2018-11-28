class DealsController < ApplicationController

  before_action :find_deal_by_id, only: %i[show]

  def show; end

  private def find_deal_by_id
    @deal = Deal.find_by(id: params[:id])
    if @deal.nil?
      redirect_to home_page_path, danger: t('.deal_not_present')
    end
  end

end
