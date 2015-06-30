# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('public','images')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets','ui-bootstrap')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets','bower_components')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets','bower_components','bootstrap')
# ActionMailer::Base.default_url_options[:host] = "anti-pms.ru"
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w(*.woff *.ttf *.svg *.eot)
