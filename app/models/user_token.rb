# frozen_string_literal: true

class UserToken < ApplicationRecord
  include ::Tokenable

  ###
  # associations
  belongs_to :user
end
