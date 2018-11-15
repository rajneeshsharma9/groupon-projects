module Admin
  class DealsController < BaseController

    before_action :find_deal_by_id, only: %i[show edit update destroy]

    def index
      @deals = Deal.order(created_at: :desc)
    end

    def show; end

    def new
      @deal = Deal.new
    end

    def edit; end

    def create
      @deal = Deal.new(deal_params)
      if @deal.save
        redirect_to admin_deals_path, info: t('.deal_saved')
      else
        render :new
      end
    end

    def update
      if @deal.update(deal_params)
        redirect_to edit_admin_deal_path(@deal.id), success: t('.deal_updated')
      else
        render :edit
      end
    end

    def destroy
      @deal.destroy
      redirect_to admin_deals_path, info: t('.deal_deleted')
    end

    private def find_deal_by_id
      @deal = Deal.find_by(id: params[:id])
      if @deal.nil?
        redirect_to admin_deals_path, danger: t('.deal_not_found')
      end
    end

    private def deal_params
      params.require(:deal).permit(:title, :description, :start_time, :expire_time, :instructions, :minimum_purchases_required, :maximum_purchases_allowed, :maximum_purchases_per_customer, :price)
    end

  end
end
