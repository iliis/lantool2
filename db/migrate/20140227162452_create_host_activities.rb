class CreateHostActivities < ActiveRecord::Migration
  def change
    create_table :host_activities do |t|
      t.string :ip
      t.string :hostname
      t.references :user
      t.string :ports

      t.timestamps
    end
    add_index :host_activities, :user_id
  end
end
