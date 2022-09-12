class AddColumnToUsersForDevise < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remember_token, :string
    add_column :users, :failed_attempts, :integer, default: 0
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
