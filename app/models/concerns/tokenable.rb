# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_token

    def generate_token
      return if token.present?

      loop do
        self.token = SecureRandom.alphanumeric(10)
        break token unless self.class.where(token:).exists?
      end
    end
  end
end
