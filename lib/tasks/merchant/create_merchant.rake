require 'io/console'
namespace :merchant do
  desc 'Create user with merchant role'
  task new: :environment do

    STDOUT.puts "Merchant creation started at #{Time.current}"
    STDOUT.print 'Enter merchant name : '
    name = STDIN.gets.strip
    STDOUT.print 'Enter merchant email : '
    email = STDIN.gets.strip
    STDOUT.print 'Enter merchant password : '
    password = STDIN.noecho(&:gets).strip
    merchant = User.merchant.new(name: name, email: email, password: password, verified_at: Time.current)
    if merchant.save
      STDOUT.puts "Merchant created successfully at #{Time.current}"
    else
      STDOUT.puts "Aborting merchant creation at #{Time.current} as #{merchant.errors.full_messages.to_sentence}"
    end
  end

end
