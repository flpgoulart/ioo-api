class AddQtyViewsToOffers < ActiveRecord::Migration[5.1]
  def change
    add_column :offers, :qty_views, :integer
  end
end
