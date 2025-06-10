class AnimeInfoBlockSerializer
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
        shikimori_id: @anime.shikimori_id,
        date: @anime.date,
        status: @anime.status,
        last_episode: @anime.last_episode,
        episodes_count: @anime.episodes_count,
        description: @anime.description,
        age_limit: @anime.age_limit,
        lgbt: @anime.lgbt,
        worldart_poster: @anime.worldart_poster,
        genres: @anime.genres
      }
    end
  end
  