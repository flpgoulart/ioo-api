class CreateBusinessAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :business_accounts do |t|
      t.string :name
      t.string :cnpj
      t.string :insce
      t.string :inscm
      t.string :city_name
      t.string :uf
      t.string :email
      t.integer :ddd_phone
      t.integer :phone
      t.integer :ddd_mobile
      t.integer :mobile
      t.string :address_name
      t.string :cep
      t.string :plan
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
