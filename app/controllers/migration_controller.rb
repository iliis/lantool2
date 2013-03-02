class MigrationController < ApplicationController
  before_filter :authenticate_admin, :only => [:export]

  def index
  end

  def export
    dump = Mysqldump.full_backup
    send_data dump, :filename => ('DATABASE_' + Date.today.to_s + '.bak')
  end
  
  def import 
    # allow import without login when there is no user in DB
    authenticate_admin if User.any?

    raise 'no file specified' if ! params[:import_file]
    Mysqldump.delete_all if params[:delete_all]

    Mysqldump.full_import_from_file(params[:import_file].path)
    redirect_to :action => :index, :notice => 'Import erfolgreich'
  end

end
