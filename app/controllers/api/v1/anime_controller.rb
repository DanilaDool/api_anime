module Api
  module V1
    class AnimeController < ApplicationController
      include Pagy::Backend

      def all
        animes = Anime.select(
          :id, :title, :title_orig, :anime_img, :worldart_poster, :score,
          :dtype, :shikimori_id, :status, :date, :last_episode,
          :episodes_count, :age_limit, :description, :genres, :lgbt, :genres
        ).order(Arel.sql("material_data->>'released_at' DESC NULLS LAST"))
      
        render json: animes.map { |a| AnimeInfoBlockSerializer.new(a).as_json }
      end
      
      def index
        # Сортировка по material_data->'released_at'
        anime_query = Anime.select(:id, :title, :anime_img, :score, :id_anime, :dtype, :shikimori_id, :worldart_poster, :updated_at, :last_episode)
                           .order(Arel.sql("material_data->>'released_at' DESC NULLS LAST"))

        @pagy, @anime = pagy(anime_query, items: 30)

        render json: {
          animes: @anime.map { |a| AnimePreviewSerializer.new(a).as_json },
          page: @pagy.page,
          pages: @pagy.pages,
          total: @pagy.count
        }
      end

      def recent
        # Сортировка по updated_at
        anime_query = Anime.select(:id, :title, :anime_img, :score, :id_anime, :dtype, :shikimori_id, :worldart_poster, :updated_at, :last_episode)
                           .order(updated_at: :desc)

        @pagy, @anime = pagy(anime_query, items: 30)

        render json: {
          animes: @anime.map { |a| AnimePreviewSerializer.new(a).as_json },
          page: @pagy.page,
          pages: @pagy.pages,
          total: @pagy.count
        }
      end

      def info_block
        anime_query = Anime.select(
          :id, :title, :anime_img, :score, :dtype, :shikimori_id, :worldart_poster,
          :status, :date, :last_episode, :episodes_count, :age_limit, :description, :lgbt, :genres
        ).order(Arel.sql("material_data->>'released_at' DESC NULLS LAST"))
      
        @pagy, @anime = pagy(anime_query, items: 30)
      
        render json: {
          animes: @anime.map { |a| AnimeInfoBlockSerializer.new(a).as_json },
          page: @pagy.page,
          pages: @pagy.pages,
          total: @pagy.count
        }
      end

      def cult_info_block
        anime_query = Anime.select(
          :id, :title, :anime_img, :score, :dtype, :shikimori_id, :worldart_poster,
          :status, :date, :last_episode, :episodes_count, :age_limit, :description, :lgbt, :genres
        )
        .where("score >= ?", 8.0)
        .order(score: :desc)
      
        @pagy, @anime = pagy(anime_query, items: 30)
      
        render json: {
          animes: @anime.map { |a| AnimeInfoBlockSerializer.new(a).as_json },
          page: @pagy.page,
          pages: @pagy.pages,
          total: @pagy.count
        }
      end
      
      def show
        anime = Anime.find_by!(shikimori_id: params[:id])
        render json: AnimeFullSerializer.new(anime).as_json
      end
    end
  end
end
