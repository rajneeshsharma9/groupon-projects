namespace :admin do
  desc 'Create user with admin role'
  task new: :environment do
    STDOUT.print 'Enter admin name : '
    name = STDIN.gets.strip
    STDOUT.print 'Enter admin email : '
    email = STDIN.gets.strip
    STDOUT.print 'Enter admin password : '
    password = STDIN.gets.strip
    admin = User.new(name: name, email: email, password: password, role: 'admin', verified_at: Time.current)
    if admin.save
      STDOUT.puts 'Admin created successfully'
    else
      STDOUT.puts admin.errors.full_messages
      STDOUT.puts 'Aborting...'
    end
  end
end
