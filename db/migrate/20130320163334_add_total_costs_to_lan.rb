class AddTotalCostsToLan < ActiveRecord::Migration
  def change
    add_column :lans, :total_costs, :float
  end
end
