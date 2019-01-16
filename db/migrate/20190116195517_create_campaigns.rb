class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :disclaimer
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
