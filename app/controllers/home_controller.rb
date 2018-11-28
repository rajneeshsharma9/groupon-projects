class HomeController < ApplicationController

  skip_before_action :authorize, only: [:index]

  def index
    if params[:search]
      @deals = Deal.filter(params[:category][:category_id]).search(params[:search]).order("created_at DESC")
    else
      @deals = Deal.order(created_at: :desc)
    end
  end

  def show; end

end
