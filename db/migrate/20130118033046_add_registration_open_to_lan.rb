class AddRegistrationOpenToLan < ActiveRecord::Migration
  def change
    add_column :lans, :registration_open, :boolean
  end
end
