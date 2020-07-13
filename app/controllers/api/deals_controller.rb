module Api
  class DealsController < BaseController

    def index
      render json: Deal.all.as_json(only: [:title, :description], include: { category: { only: [:name] } })
    end

  end
end
