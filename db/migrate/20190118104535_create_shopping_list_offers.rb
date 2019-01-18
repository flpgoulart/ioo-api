class CreateShoppingListOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :shopping_list_offers do |t|
      t.references :shopping_list, foreign_key: true
      t.references :offer, foreign_key: true
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
