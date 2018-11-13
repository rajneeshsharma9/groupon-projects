require 'io/console'
namespace :admin do
  desc 'Create user with admin role'
  task new: :environment do

    STDOUT.puts "Admin creation started at #{ Time.current }"
    STDOUT.print 'Enter admin name : '
    name = STDIN.gets.strip
    STDOUT.print 'Enter admin email : '
    email = STDIN.gets.strip
    STDOUT.print 'Enter admin password : '
    password = STDIN.noecho(&:gets).strip
    admin = User.admin.new(name: name, email: email, password: password, verified_at: Time.current)
    if admin.save
      STDOUT.puts "Admin created successfully at #{ Time.current }"
    else
      STDOUT.puts "Aborting admin creation at #{ Time.current } as #{ admin.errors.full_messages.to_sentence }"
    end
  end

end
