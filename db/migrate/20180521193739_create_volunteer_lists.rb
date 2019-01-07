class CreateVolunteerLists < ActiveRecord::Migration[5.0]
  def change
    create_table :volunteer_lists do |t|
      t.references :volunteer, foreign_key: true
      t.references :improvement, foreign_key: true
      t.boolean :attendance
      t.integer :rate_volunteer
      t.integer :rate_improvement
      t.integer :rate_social_entity
      
      t.timestamps
    end
  end
end
