class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :number,    :limit => 23
      t.string :bank_code, :limit => 8
      t.string :type,      :limit => 64

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
