# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    followee_ids = user.followees(User).pluck(:id)

    can %i(manage), SleepTime, user_id: user.id
    can %i(read), SleepTime, user_id: followee_ids
  end
end
