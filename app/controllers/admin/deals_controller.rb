module Admin
  class DealsController < BaseController

    before_action :find_deal_by_id, only: %i[show edit update destroy publish unpublish]

    def index
      @deals = Deal.includes(:collection).order(created_at: :desc)
    end

    def show; end

    def new
      @deal = Deal.new
    end

    def edit; end

    def create
      Deal.transaction do
        @deal = Deal.new(permitted_deal_params)
        attach_images
        unless @deal.save
          raise ActiveRecord::Rollback
        end
      end
      if @deal.persisted?
        redirect_to admin_deal_path(@deal), info: t('.deal_created')
      else
        flash.now[:danger] = @deal.errors.full_messages.join(', ')
        render :new
      end
    end

    def update
      Deal.transaction do
        attach_images
        unless @deal.update(permitted_deal_params)
          raise ActiveRecord::Rollback
        end
      end
      if @deal.errors.empty?
        redirect_to admin_deal_path(@deal), success: t('.deal_updated')
      else
        flash.now[:danger] = @deal.errors.full_messages.join('<br>')
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

    def publish
      if @deal.publish
        render json: { id: @deal.id, published_at: @deal.published_at.to_s(:long) }
      else
        render json: { errors: @deal.errors.full_messages.join(', ') }, status: 422
      end
    end

    def unpublish
      if @deal.unpublish
        render json: { id: @deal.id }
      else
        render json: { errors: @deal.errors.full_messages.join(', ') }, status: 422
      end
    end

    private def find_deal_by_id
      @deal = Deal.find_by(id: params[:id])
      if @deal.nil?
        redirect_to admin_deals_path, danger: t('.deal_not_found')
      end
    end

    private def attach_images
      if params[:deal][:images].present?
        @deal.images.attach(params[:deal][:images].values)
      end
    end

    private def permitted_deal_params
      params.require(:deal).permit(:title, :description, :start_at, :expire_at, :instructions, :minimum_purchases_required, :maximum_purchases_allowed, :maximum_purchases_per_customer, :price, :category_id, images_attachments_attributes: %i[id _destroy], location_ids: [])
    end

  end
end
