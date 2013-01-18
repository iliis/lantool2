class AddRegistrationDateToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :registration_date, :datetime
  end
end
