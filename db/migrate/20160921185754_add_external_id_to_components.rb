class AddExternalIdToComponents < ActiveRecord::Migration
  def change
    add_column :components, :external_id, :string, default: nil
  end
end
