class AddWorldartAttribute < ActiveRecord::Migration[8.0]
  def change
    add_column :animes, :worldart_poster, :string
  end
end
