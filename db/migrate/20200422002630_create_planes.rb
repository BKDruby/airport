class CreatePlanes < ActiveRecord::Migration
  def change
    create_table :planes do |t|
      t.integer :status, default: 0
      t.string :title
      t.timestamps null: false
    end
  end
end
