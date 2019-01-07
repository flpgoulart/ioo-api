class AddAddressCompToSocialEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :social_entities, :address_comp, :string
  end
end
