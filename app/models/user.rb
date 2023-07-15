# frozen_string_literal: true

class User < ApplicationRecord
  ###
  # constants
  SIGN_IN_PARAMS = %i(email password).freeze

  ###
  # helpers
  acts_as_follower
  acts_as_followable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ###
  # associations
  has_many :sleep_times, dependent: :destroy
  has_many :user_tokens, dependent: :destroy

  ###
  # validations
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }

  def current_user? user
    self == user
  end
end
