class CreatePantryItems < ActiveRecord::Migration[6.0]
  def change
    create_table :pantry_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
