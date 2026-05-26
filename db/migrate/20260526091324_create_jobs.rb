class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :title

      t.timestamps
    end
  end
end
