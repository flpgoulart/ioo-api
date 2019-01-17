class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.references :store_type, foreign_key: true
      t.references :business, foreign_key: true
      t.references :city, foreign_key: true
      t.string :cep
      t.string :address_name
      t.string :contact_info
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
