module Merchant
  class CouponsController < BaseController

    before_action :find_coupon_by_code, only: %i[update]
    before_action :find_coupon_by_id, only: %i[show]

    def index
      @coupons = Coupon.all
    end

    def show; end

    def redeem; end

    def update
      if @coupon.redeem(current_user)
        redirect_to merchant_coupons_path, success: t('.coupon_successfully_redeemed')
      else
        redirect_to redeem_merchant_coupons_path, danger: t('.coupon_already_redeemed')
      end
    end

    private def find_coupon_by_code
      @coupon = Coupon.find_by(code: params[:code])
      if @coupon.nil?
        redirect_to redeem_merchant_coupons_path, danger: t('.invalid_coupon_code')
      end
    end

    private def find_coupon_by_id
      @coupon = Coupon.find_by(id: params[:id])
      if @coupon.nil?
        redirect_to merchant_coupons_path, danger: t('.coupon_not_found')
      end
    end

  end
end
