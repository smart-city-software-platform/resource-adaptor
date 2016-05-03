class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.float :lat
      t.float :lon
      t.text :capacities
      t.text :description
      t.references :basic_resource
      t.timestamps null: false
    end
  end
end
