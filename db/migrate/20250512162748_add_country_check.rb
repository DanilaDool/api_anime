class AddCountryCheck < ActiveRecord::Migration[8.0]
  def change
    add_column :animes, :worldart_country, :string
  end
end
