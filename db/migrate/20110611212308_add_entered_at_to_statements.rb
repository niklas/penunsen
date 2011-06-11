class AddEnteredAtToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :entered_at, :datetime
  end
end
