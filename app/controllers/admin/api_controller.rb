module Admin
  class ApiController < BaseController

    def generate_token
      loop do
        current_user.api_token = Tokenizer.new_token
        if User.find_by(api_token: current_user.api_token).nil?
          break
        end
      end
      if current_user.save
        redirect_to admin_deals_path, success: "Here is your API token: #{current_user.api_token}"
      else
        redirect_to admin_deals_path, danger: "An error has occurred"
      end
    end

  end
end
