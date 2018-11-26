namespace :category do
  desc 'Create category'
  task new: :environment do
    STDOUT.puts "Category creation started at #{ Time.current }"
    STDOUT.print 'Enter category name : '
    name = STDIN.gets.strip
    category = Category.new(name: name)
    if category.save
      STDOUT.puts "Category created successfully at #{ Time.current }"
    else
      STDOUT.puts "Aborting category creation at #{ Time.current } as #{ category.errors.full_messages.to_sentence }"
    end
  end

end
