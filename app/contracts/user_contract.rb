# frozen_string_literal: true

class UserContract < ApplicationContract
  include SharedConstraints
  include EmailConstraints

  MIN_BIRTH_DATE = Time.zone.now.to_date.freeze
  MAX_BIRTH_DATE = 120.years.ago.to_date.freeze

  attr_reader :action

  def initialize(action)
    super
    @action = action.to_sym
  end

  params do
    optional(:name).filled(:str?, format?: NO_UNSAFE_CHARACTERS, min_size?: 2, max_size?: 255)
    optional(:email).filled(:str?, min_size?: 6, max_size?: 255)
    optional(:birth_date).filled(:str?, format?: SQL_DATE)
  end

  rule do
    next unless action == :create

    key(:name).failure(:key?) unless values.key?(:name)
    key(:email).failure(:key?) unless values.key?(:email)
    key(:birth_date).failure(:key?) unless values.key?(:birth_date)
  end

  rule(:email) do
    next unless key?

    key.failure('is missing @ character') && next if value.exclude?('@')
    local, domain = value.split('@')
    key.failure('local has invalid characters') && next unless EMAIL_LOCAL.match?(local)
    key.failure('domain has subsequent dot characters') && next if SUBSEQUENT_DOTS.match?(domain)
    key.failure('domain has leading dot character') && next if domain.start_with?('.')
    key.failure('domain has trailing dot character') && next if domain.end_with?('.')
    key.failure('domain has leading whitespace character') && next if domain != domain.lstrip
    key.failure('domain has trailing whitespace character') && next if domain != domain.rstrip
    subdomains = domain.split('.')
    key.failure('domain does not have dot character') && next if subdomains.size < 2
    subdomains.each do |sub|
      key.failure("subdomain #{sub} has invalid chars") && next unless EMAIL_SUBDOMAIN.match?(sub)
      key.failure("subdomain #{sub} has leading hyphen") && next if sub.start_with?('-')
      key.failure("subdomain #{sub} has trailing hyphen") && next if sub.end_with?('-')
    end
  end

  rule(:birth_date) do
    next unless key?

    key.failure(:date?) && next if invalid_date?(value)
    key.failure(:too_early, min: MIN_BIRTH_DATE) if value.to_date > MIN_BIRTH_DATE
    key.failure(:too_late, max: MAX_BIRTH_DATE) if value.to_date < MAX_BIRTH_DATE
  end
end
