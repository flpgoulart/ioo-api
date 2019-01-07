class CreateVolunteers < ActiveRecord::Migration[5.0]
  def change
    create_table :volunteers do |t|
      t.string :name
      t.string :address
      t.string :address_comp
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
