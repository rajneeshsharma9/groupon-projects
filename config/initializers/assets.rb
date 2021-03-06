# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/*"]
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[admin.scss]
Rails.application.config.assets.precompile += %w[admin.js admin/rich_html_editor_handler.js admin/select2_handler.js admin/record_publisher.js admin/image_destroy_handler.js admin/multiple_input_field_handler.js deal_ajax_polling.js]
