class AddFakeFlagToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :fake, :boolean
  end
end
