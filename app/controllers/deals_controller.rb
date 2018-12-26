class DealsController < ApplicationController

  before_action :find_deal_by_id, only: %i[show check_sold_quantity]

  def show; end

  def check_sold_quantity
    if params[:current_quantity_sold] != @deal.quantity_sold
      render json: { id: @deal.id, quantity_sold: @deal.quantity_sold, percentage_sold: @deal.percentage_sold }
    else
      render json: { id: @deal.id }, status: 304
    end
  end

  private def find_deal_by_id
    @deal = Deal.find_by(id: params[:id])
    if @deal.nil?
      respond_to do |format|
        format.html { redirect_to home_page_path, danger: t('.deal_not_present') }
        format.json { render json: { id: @deal.id }, status: 404 }
      end
    end
  end

end
