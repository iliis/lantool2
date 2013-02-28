class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.references :user
      t.date :day
      t.integer :hour
      t.integer :activity_count

      t.timestamps
    end
  end
end
