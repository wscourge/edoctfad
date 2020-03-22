# frozen_string_literal: true

require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Daftcode
  class Application < Rails::Application
    config.api_only = true
    config.load_defaults(6.0)
    config.generators do |generator|
      generator.test_framework(
        :rspec,
        fixtures: true,
        controller_specs: true,
        routing_specs: true,
        request_specs: true
      )
      generator.fixture_replacement(:factory_bot, dir: 'spec/factories')
    end
  end
end
