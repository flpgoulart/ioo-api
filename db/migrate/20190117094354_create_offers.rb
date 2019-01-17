class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :name
      t.string :brand_name
      t.references :product, foreign_key: true
      t.references :campaign, foreign_key: true
      t.text :disclaimer
      t.string :status
      t.references :unit_measure, foreign_key: true
      t.float :product_value
      t.float :offer_value
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
