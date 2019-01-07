class CreateSocialEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :social_entities do |t|
      t.string :name
      t.text :about_us
      t.string :phone_number
      t.string :mobile_number
      t.string :email_contact
      t.string :site
      t.string :address
      t.references :user, foreign_key: true
      t.references :target_audience, foreign_key: true
      t.references :occupation_area, foreign_key: true

      t.timestamps
    end
  end
end
