class CreateBillings < ActiveRecord::Migration[5.0]
  def change
    create_table :billings do |t|
      t.string :document
      t.datetime :doc_date
      t.datetime :ref_ini_date
      t.datetime :ref_end_date
      t.string :link_document
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
