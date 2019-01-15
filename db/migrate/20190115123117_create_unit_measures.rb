class CreateUnitMeasures < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_measures do |t|
      t.string :name

      t.timestamps
    end
  end
end
