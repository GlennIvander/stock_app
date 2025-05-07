class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :balance, :integer
    add_column :users, :is_pending, :boolean, default: true
  end
end
