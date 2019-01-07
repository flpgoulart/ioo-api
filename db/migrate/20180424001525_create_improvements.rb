class CreateImprovements < ActiveRecord::Migration[5.0]
  def change
    create_table :improvements do |t|
      t.string :title
      t.text :short_description
      t.text :description
      t.string :address
      t.string :address_comp
      t.integer :limit_volunteers
      t.datetime :start_date
      t.datetime :end_date
      t.text :knowledge_required
      t.text :support_materials
      t.string :status
      t.references :social_entity, foreign_key: true

      t.timestamps
    end
  end
end
