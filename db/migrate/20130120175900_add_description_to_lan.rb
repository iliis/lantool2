class AddDescriptionToLan < ActiveRecord::Migration
  def change
    add_column :lans, :description, :string
  end
end
