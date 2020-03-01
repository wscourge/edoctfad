# frozen_string_literal: true

module SharedConstraints
  SQL_DATE = %r{\A\d{4}-\d{2}-\d{2}$|^\d{4}/\d{2}/\d{2}\z}.freeze
  # https://www.postgresql.org/docs/10/datatype-numeric.html
  SQL_BIG_INT = /\A[1-9]{1}\d{,18}\z/.freeze
  UNACCEPTABLE_CHARACTERS = '!@#$%^&*_=+<>/{}~`'
  NO_UNSAFE_CHARACTERS = /\A((?![#{UNACCEPTABLE_CHARACTERS}]).)*\z/.freeze

  def invalid_date?(string)
    !Date.valid_date?(*string.split(string.include?('/') ? '/' : '-').map(&:to_i))
  end
end
