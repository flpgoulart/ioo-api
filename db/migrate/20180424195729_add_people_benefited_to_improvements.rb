class AddPeopleBenefitedToImprovements < ActiveRecord::Migration[5.0]
  def change
    add_column :improvements, :people_benefited, :integer
  end
end
