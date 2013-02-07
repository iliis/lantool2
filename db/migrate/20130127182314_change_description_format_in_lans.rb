class ChangeDescriptionFormatInLans < ActiveRecord::Migration
  def change
    change_column :lans, :description, :text
  end
end
