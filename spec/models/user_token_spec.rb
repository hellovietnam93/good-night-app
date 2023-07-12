# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserToken, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'Tokenable module' do
    it 'generates a unique token before validation' do
      user_token = build(:user_token)
      user_token.valid?
      expect(user_token.token).to be_present
    end
  end

  describe 'generate_token' do
    it 'generates a unique token' do
      user_token = build(:user_token)
      user_token.generate_token
      expect(user_token.token).to be_present
    end

    it 'generates a token that is not already used' do
      existing_token = 'existing_token'
      allow(UserToken).to receive_message_chain(:where, :exists?).and_return(true, false)
      allow(SecureRandom).to receive(:alphanumeric).and_return(existing_token, 'new_token')

      user_token = build(:user_token)
      user_token.generate_token
      expect(user_token.token).not_to eq(existing_token)
    end
  end
end
