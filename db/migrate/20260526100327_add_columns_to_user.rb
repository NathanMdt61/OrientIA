class AddColumnsToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :user_name, :string
    add_column :users, :age, :integer
    add_column :users, :school_level, :string
    add_column :users, :goal, :string
  end
end
