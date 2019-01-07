class AddFacebookUrlToSocialEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :social_entities, :facebook_url, :string
  end
end
