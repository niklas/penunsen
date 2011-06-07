class CreateStatements < ActiveRecord::Migration
  def self.up
    create_table :statements do |t|
      t.date :entered_on
      t.integer :amount
      t.string :funds_code, :limit => 16
      t.string :account_holder, :limit => 256
      t.string :account_number, :limit => 23
      t.string :bank_code, :limit => 8
      t.integer :prima_nota
      t.string :description, :limit => 64
      t.text :details
      t.string :balance_sign, :limit => 16
      t.integer :balance_amount
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :statements
  end
end
