class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :localization
      t.integer :uui
      t.text :description
      t.timestamps null: false
    end
  end
end
