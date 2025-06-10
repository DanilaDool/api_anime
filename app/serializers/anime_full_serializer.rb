class AnimeFullSerializer
    def initialize(anime)
      @anime = anime
    end
  
    def as_json(*)
      {
        id: @anime.id,
        title: @anime.title,
        title_orig: @anime.title_orig,
        other_title: @anime.other_title,
        image: @anime.anime_img,
        score: @anime.score,
        dtype: @anime.dtype,
        id_anime: @anime.id_anime,
        shikimori_id: @anime.shikimori_id,
        date: @anime.date,
        status: @anime.status,
        last_season: @anime.last_season,
        last_episode: @anime.last_episode,
        episodes_count: @anime.episodes_count,
        duration: @anime.duration,
        link: @anime.link,
        description: @anime.description,
        translation: @anime.translation,
        genres: @anime.genres,
        rating_mpaa: @anime.rating_mpaa,
        age_limit: @anime.age_limit,
        lgbt: @anime.lgbt,
        camrip: @anime.camrip,
        screenshots: @anime.screenshots,
        material_data: @anime.material_data,
        studios: @anime.studios,
        worldart_country: @anime.worldart_country,
        worldart_link: @anime.worldart_link,
        worldart_poster: @anime.worldart_poster,
        imdb_id: @anime.imdb_id,
        kinopoisk_id: @anime.kinopoisk_id,
        blocked_countries: @anime.blocked_countries,
        blocked_seasons: @anime.blocked_seasons
      }
    end
  end
  