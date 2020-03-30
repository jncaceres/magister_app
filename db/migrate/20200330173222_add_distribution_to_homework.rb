class AddDistributionToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks, :distribution, :integer
  end
end
