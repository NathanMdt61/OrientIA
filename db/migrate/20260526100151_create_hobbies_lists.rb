class CreateHobbiesLists < ActiveRecord::Migration[8.1]
  def change
    create_table :hobbies_lists do |t|
      t.references :hobbie, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
