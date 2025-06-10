class AnimePreviewSerializer
    def initialize(anime)
      @anime = anime
    end
  
    def as_json(*)
      {
        id: @anime.id,
        title: @anime.title,
        image: @anime.anime_img,
        score: @anime.score,
        dtype: @anime.dtype,
        id_anime: @anime.id_anime,
        worldart_poster: @anime.worldart_poster,
        shikimori_id: @anime.shikimori_id,
        updated_at: @anime.updated_at,
        last_episode: @anime.last_episode
      }
    end
  end
  