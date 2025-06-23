# config/initializers/dartsass.rb
Rails.application.config.dartsass.build_options << "--poll" if Rails.env.development?
Rails.application.config.dartsass.builds = {
  "*.sass"  => "*.css",
}