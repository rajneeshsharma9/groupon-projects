module Admin
  class CollectionsController < BaseController

    before_action :find_collection_by_id, only: %i[show edit update destroy publish unpublish]

    def index
      @collections = Collection.order(created_at: :desc)
    end

    def show; end

    def new
      @collection = Collection.new
    end

    def edit; end

    def create
      @collection = Collection.new(permitted_collection_params)
      if @collection.save
        redirect_to admin_collection_path(@collection), info: t('.collection_created')
      else
        flash.now[:danger] = t('.error_has_occured')
        render :new
      end
    end

    def update
      if @collection.update(permitted_collection_params)
        redirect_to admin_collection_path(@collection), success: t('.collection_updated')
      else
        flash.now[:danger] = @collection.errors.full_messages.join('<br>')
        render :edit
      end
    end

    def destroy
      if @collection.destroy
        redirect_to admin_collection_path, info: t('.collection_deleted')
      else
        redirect_to admin_collection_path, danger: t('.error_has_occured')
      end
    end

    def publish
      if @collection.publish
        render json: { id: @collection.id, published_at: @collection.published_at.to_s(:long) }
      else
        render json: { errors: @collection.errors.full_messages.join(', ') }, status: 422
      end
    end

    def unpublish
      if @collection.unpublish
        render json: { id: @collection.id }
      else
        render json: { errors: @collection.errors.full_messages.join(', ') }, status: 422
      end
    end

    private def find_collection_by_id
      @collection = Collection.find_by(id: params[:id])
      if @collection.nil?
        redirect_to admin_collections_path, danger: t('.collection_not_found')
      end
    end

    private def permitted_collection_params
      params.require(:collection).permit(:name, deal_ids: [])
    end

  end
end
