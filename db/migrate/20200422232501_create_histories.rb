class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :plane
      t.integer :prev_status
      t.integer :new_status
      t.timestamps null: false
    end
  end
end
