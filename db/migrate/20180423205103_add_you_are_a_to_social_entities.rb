class AddYouAreAToSocialEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :social_entities, :you_are_a, :string
  end
end
