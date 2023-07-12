# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepTime, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:sleep_time) }
    it { should validate_presence_of(:wake_up_time) }

    context 'when sleep_time is after wake_up_time' do
      let(:sleep_time) { Time.now }
      let(:wake_up_time) { Time.now - 1.hour }
      let(:sleep_time_record) { build(:sleep_time, sleep_time:, wake_up_time:) }

      it 'is not valid' do
        expect(sleep_time_record).not_to be_valid
        expect(sleep_time_record.errors[:base]).to include('Wake up time must be after sleep time')
      end
    end

    context 'when sleep time overlaps with an existing record' do
      let(:user) { create :user }
      let!(:existing_sleep_time) do
        create(:sleep_time, user:, sleep_time: Time.now - 1.hour, wake_up_time: Time.now + 1.hour)
      end
      let(:sleep_time_record) do
        build(:sleep_time, user:, sleep_time: Time.now, wake_up_time: Time.now + 1.hour)
      end

      it 'is not valid' do
        expect(sleep_time_record).not_to be_valid
        expect(sleep_time_record.errors[:base]).to include('Sleep time overlaps with an existing record')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
