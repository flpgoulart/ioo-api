class CreateStoreCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :store_campaigns do |t|
      t.references :store, foreign_key: true
      t.references :campaign, foreign_key: true
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
