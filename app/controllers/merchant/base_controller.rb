module Merchant
  class BaseController < ApplicationController

    before_action :ensure_user_is_merchant

    layout 'merchant'
    # to check if user is merchant
    private def ensure_user_is_merchant
      unless current_user.merchant?
        redirect_to home_page_path, danger: t('.not_merchant')
      end
    end

  end
end
