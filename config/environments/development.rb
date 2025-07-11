require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configuración básica para desarrollo
  config.enable_reloading = true
  config.eager_load = false

  # Mostrar errores detallados
  config.consider_all_requests_local = true
  config.action_dispatch.show_exceptions = true
  config.action_dispatch.show_detailed_exceptions = true

  # Permitir todos los hosts en desarrollo
  # config.hosts = nil

  # Configuración adicional para Docker
  config.hosts << "host.docker.internal"
  config.hosts << "localhost"
  config.hosts << "0.0.0.0"
  config.hosts << "a941-62-83-12-14.ngrok-free.app"

  # Configuración de web console
  config.web_console.whitelisted_ips = ['0.0.0.0', '127.0.0.1', '172.19.0.1', '0.0.0.0', '37.223.242.100', '172.21.0.1', '172.18.0.1']
  config.web_console.development_mode = true

  # Configuración de caching
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end
  config.cache_store = :memory_store

  # Configuración de mailer
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Configuración de logging
  config.log_level = :debug
  config.active_support.deprecation = :log
  config.active_job.verbose_enqueue_logs = true

  # Opciones adicionales de desarrollo
  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.raise_on_missing_callback_actions = true

  # Desactivar cualquier aplicación de excepciones personalizada
  config.exceptions_app = nil

  # Configuración de server timing
  config.server_timing = true

  # Enable/disable Action Cable access from any origin
  # config.action_cable.disable_request_forgery_protection = true

  # Raises error for missing translations
  config.i18n.raise_on_missing_translations = false

  # Apply autocorrection by RuboCop to files generated by `bin/rails generate`.
  # config.generators.apply_rubocop_autocorrect_after_generate!
end