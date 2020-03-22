# frozen_string_literal: true

class ResourceIdentifierContract < ApplicationContract
  include SharedConstraints

  params do
    required(:id).filled(:str?, format?: SQL_BIG_INT)
  end
end
