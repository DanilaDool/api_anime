class AddFieldsToAnimes < ActiveRecord::Migration[8.0]
    def change
      add_column :animes, :shikimori_id, :integer unless column_exists?(:animes, :shikimori_id)
      add_column :animes, :title, :string unless column_exists?(:animes, :title)
      add_column :animes, :anime_img, :string
      add_column :animes, :dtype, :string
      add_column :animes, :date, :string
      add_column :animes, :status, :string
      add_column :animes, :score, :float
      add_column :animes, :id_anime, :string
      add_column :animes, :link, :string
      add_column :animes, :title_orig, :string
      add_column :animes, :other_title, :string
      add_column :animes, :last_season, :integer
      add_column :animes, :last_episode, :integer
      add_column :animes, :episodes_count, :integer
      add_column :animes, :kinopoisk_id, :string
      add_column :animes, :worldart_link, :string
      add_column :animes, :imdb_id, :string
      add_column :animes, :mdl_id, :string
      add_column :animes, :quality, :string
      add_column :animes, :camrip, :boolean
      add_column :animes, :lgbt, :boolean
      add_column :animes, :blocked_countries, :text, array: true, default: []
      add_column :animes, :blocked_seasons, :jsonb, default: {}
      add_column :animes, :screenshots, :text, array: true, default: []
      add_column :animes, :translation, :jsonb, default: {}
      add_column :animes, :genres, :jsonb, default: {}
      add_column :animes, :rating_mpaa, :string
      add_column :animes, :next_episode_at, :string
      add_column :animes, :studios, :jsonb, default: {}
      add_column :animes, :videos, :jsonb, default: {}
      add_column :animes, :duration, :integer
      add_column :animes, :description, :string
      add_column :animes, :aired_at, :string
      add_column :animes, :released_at, :string
      add_column :animes, :minimal_age, :integer
      add_column :animes, :not_blocked_in, :string
      add_column :animes, :not_blocked_for_me, :boolean
      add_column :animes, :material_data, :jsonb, default: {}
      change_column_default :animes, :material_data, nil
      add_column :animes, :age_limit, :integer
      add_index :animes, :title, using: :gin, opclass: :gin_trgm_ops
    end
  end
