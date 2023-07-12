# frozen_string_literal: true

class User < ApplicationRecord
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
end
