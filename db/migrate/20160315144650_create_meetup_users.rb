class CreateMeetupUsers < ActiveRecord::Migration
  def change
    create_table :meetup_users do |table|
      table.integer :user_id, null: false
      table.integer :meetup_id, null: false
      table.integer :meetup_creator_id, null: false
    end
  end
end
