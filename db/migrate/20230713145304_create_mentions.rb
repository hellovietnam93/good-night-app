# frozen_string_literal: true

class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.string  :mentioner_type
      t.integer :mentioner_id
      t.string  :mentionable_type
      t.integer :mentionable_id
      t.datetime :created_at
    end

    add_index :mentions, %w(mentioner_id mentioner_type), name: "fk_mentions"
    add_index :mentions, %w(mentionable_id mentionable_type), name: "fk_mentionables"
  end
end
