# frozen_string_literal: true

class CreateUserTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tokens do |t|
      t.references :user
      t.string :token
      t.string :user_agent

      t.timestamps
    end

    add_index :user_tokens, :token, unique: true
  end
end
