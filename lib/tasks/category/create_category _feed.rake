namespace :category do
  desc 'Create default categories'
  task feed: :environment do
    STDOUT.puts "Categories creation started at #{ Time.current }"
    categories = ['health', 'hotels', 'movies', 'spa', 'food']
    categories.each do |category_name|
      category = Category.new(name: category_name)
        if category.save
        STDOUT.puts "Category created successfully at #{ Time.current }"
       else
        STDOUT.puts "Aborting category creation at #{ Time.current } as #{ category.errors.full_messages.to_sentence }"
      end
    end
    STDOUT.puts "#{categories.count} categories created successfully at #{ Time.current }"
  end
end
