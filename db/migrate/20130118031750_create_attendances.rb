class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.text :comment
      t.decimal :days_registered
      t.decimal :days_participated
      t.boolean :paid
      t.decimal :fee
      t.references :user
      t.references :lan

      t.timestamps
    end
    add_index :attendances, :user_id
    add_index :attendances, :lan_id
  end
end
