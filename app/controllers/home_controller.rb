class HomeController < ApplicationController

  skip_before_action :authorize, only: [:index]

  def index
    @deals = Deal.order(created_at: :desc)
  end

end
