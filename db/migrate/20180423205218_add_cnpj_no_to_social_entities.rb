class AddCnpjNoToSocialEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :social_entities, :cnpj_no, :string
  end
end
