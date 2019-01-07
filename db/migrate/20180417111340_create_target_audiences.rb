class CreateTargetAudiences < ActiveRecord::Migration[5.0]
  def change
    create_table :target_audiences do |t|
      t.string :name

      t.timestamps
    end
  end
end
