class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :localization
      t.text :capacities
      t.text :description
      t.references :basic_resource
      t.timestamps null: false
    end
  end
end
