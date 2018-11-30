class HomeController < ApplicationController

  skip_before_action :authorize, only: [:index]

  def index
    if params[:q]
      @deals = Deal.published.includes(:category).filter(permitted_filter_params).search(params[:q][:search]).order('created_at DESC')
    else
      @deals = Deal.published.includes(:category).order(created_at: :desc)
    end
  end

  def show; end

  private def permitted_filter_params
    params[:q].except(:search).permit!.to_h.delete_if { |_filter_key, filter_value| filter_value.empty? }
  end

end
