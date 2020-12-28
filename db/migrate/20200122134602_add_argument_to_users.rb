class AddArgumentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :argument, :integer
  end
end
