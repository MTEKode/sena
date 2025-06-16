# config/initializers/dartsass.rb
Rails.application.config.dartsass.build_options << "--poll"
Rails.application.config.dartsass.builds = {
  "application.sass"  => "application.css",
}