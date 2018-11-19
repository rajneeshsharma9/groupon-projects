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
      @deal = Deal.new(permitted_deal_params)
      if @deal.save
        redirect_to admin_deal_path(@deal), info: t('.deal_created')
      else
        render :new
      end
    end

    def update
      if @deal.update(permitted_deal_params)
        redirect_to admin_deal_path(@deal), success: t('.deal_updated')
      else
        render :edit
      end
    end

    def destroy
      if @deal.destroy
        redirect_to admin_deals_path, info: t('.deal_deleted')
      else
        redirect_to admin_deals_path, info: t('.error_has_occured')
      end
    end

    private def find_deal_by_id
      @deal = Deal.find_by(id: params[:id])
      if @deal.nil?
        redirect_to admin_deals_path, danger: t('.deal_not_found')
      end
    end

    private def permitted_deal_params
      params.require(:deal).permit(:title, :description, :start_at, :expire_at, :instructions, :minimum_purchases_required, :maximum_purchases_allowed, :maximum_purchases_per_customer, :price)
    end

  end
end
