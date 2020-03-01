# frozen_string_literal: true

module EmailConstraints
  EMAIL_LOCAL = %r{\A[a-zA-Z0-9!#$%&\'*+\/=?^_`{|}~\.-]+\z}.freeze
  SUBSEQUENT_DOTS = /\.{2,}/.freeze
  EMAIL_SUBDOMAIN = /\A[a-z0-9-]+\z/.freeze
end
