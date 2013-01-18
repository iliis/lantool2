class CreateLans < ActiveRecord::Migration
  def change
    create_table :lans do |t|
      t.string :place
      t.datetime :starttime
      t.datetime :endtime

      t.timestamps
    end
  end
end
