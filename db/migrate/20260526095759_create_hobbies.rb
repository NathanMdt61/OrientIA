class CreateHobbies < ActiveRecord::Migration[8.1]
  def change
    create_table :hobbies do |t|
      t.string :title

      t.timestamps
    end
  end
end
