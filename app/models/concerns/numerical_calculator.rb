module NumericalCalculator

  extend ActiveSupport::Concern

  def percentage_sold
    (quantity_sold / maximum_purchases_allowed.to_f * 100).to_i
  end

end
