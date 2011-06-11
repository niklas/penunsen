class AddStartBalanceToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :start_balance, :integer
    add_column :accounts, :start_balance_sign, :string, :limit => 16
  end
end
