class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.text :description
      t.string :link
      t.attachment :icon
      t.attachment :screenshot

      t.timestamps
    end
  end
end
