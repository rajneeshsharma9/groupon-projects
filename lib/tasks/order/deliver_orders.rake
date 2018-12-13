namespace :order do
  desc 'Deliver / Cancel expired deal orders'
  task deliver: :environment do
    STDOUT.puts "Delivery / Cancellation of expired deals started at #{ Time.current }"
    yesterday_expired_deals = Deal.expired_today
    yesterday_expired_deals.each do |deal|
      if deal.minimum_criteria_met?
        STDOUT.puts "Sending coupons for deal #{ deal.title } at #{ Time.current }"
        deal.generate_coupons
      else
        STDOUT.puts "Cancelling orders for deal #{ deal.title } at #{ Time.current }"
        deal.cancel_orders
      end
    end
  end
end
