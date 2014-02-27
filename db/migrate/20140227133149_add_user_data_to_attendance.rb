class AddUserDataToAttendance < ActiveRecord::Migration
  def self.up
    add_column :attendances, :user_name, :string
    add_column :attendances, :user_nick, :string
    add_column :attendances, :user_email, :string

    Attendance.reset_column_information
    atts = Attendance.all
    atts.each do |att|
      if !(att.user.nil?) and att.user_name.nil? and att.user_email.nil?
        puts "filling in data from existing user"
        att.user_name  = att.user.name
        att.user_email = att.user.email
        att.user_nick  = att.user.nick
        att.save
      end
    end
  end

  def self.down
    remove_column :attendances, :user_name
    remove_column :attendances, :user_nick
    remove_column :attendances, :user_email
  end
end
