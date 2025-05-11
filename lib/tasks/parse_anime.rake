namespace :parse_anime do
  task parse_data: :environment do
    url = 'https://kodikapi.com/list?token=5806763453666325d912b64d6031b627&types=anime-serial,anime&with_material_data=true'

    begin
      json_data = URI.open(url).read
      data = JSON.parse(json_data)

      data['results'].each do |anime_data|
        shikimori_id = anime_data['shikimori_id']
        material_data = anime_data['material_data'] || {}

        title_orig = anime_data['title_orig']
        other_titles_jp = material_data['other_titles_jp'] || []
        studios = material_data['anime_studios'] || []
        kind = material_data['anime_kind']

        is_chinese, reason = is_probably_chinese?(title_orig, other_titles_jp, studios, kind, material_data)

        if is_chinese
          puts "⛔️ Skipped chinese anime: #{title_orig} | Причина: #{reason}"
          next
        else
          puts "✅ Пропущено фильтрование: #{title_orig} | Причина: #{reason}"
        end
        

        anime = Anime.find_or_initialize_by(shikimori_id: shikimori_id)

        if anime.shikimori_id && %w[anime-serial anime].include?(anime_data['type']) && material_data.present?
          anime.anime_img = cover_url(shikimori_id) if anime.anime_img.blank?

          anime.id_anime = anime_data['id']
          anime.title = anime_data['title'].gsub(/\s*\[ТВ-(\d+).*?\]\s*/, ' \1')
          anime.title_orig = anime_data['title_orig']
          anime.other_title = anime_data['other_title']
          anime.date = anime_data['year']
          anime.dtype = anime_data['type']
          anime.created_at = anime_data['created_at']
          anime.updated_at = anime_data['updated_at']
          anime.link = anime_data['link']
          anime.not_blocked_in = anime_data['not_blocked_in']
          anime.not_blocked_for_me = anime_data['not_blocked_for_me']
          anime.last_season = anime_data['last_season']
          anime.last_episode = anime_data['last_episode']
          anime.episodes_count = anime_data['episodes_count']
          anime.kinopoisk_id = anime_data['kinopoisk_id']
          anime.worldart_link = anime_data['worldart_link']
          anime.imdb_id = anime_data['imdb_id']
          anime.mdl_id = anime_data['mdl_id']
          anime.quality = anime_data['quality']
          anime.camrip = anime_data['camrip']
          anime.lgbt = anime_data['lgbt']
          anime.blocked_countries = anime_data['blocked_countries']
          anime.blocked_seasons = anime_data['blocked_seasons']
          anime.screenshots = anime_data['screenshots']
          anime.translation = anime_data['translation']

          anime.genres = if anime.genres.blank?
                           material_data['anime_genres']&.map(&:downcase) || []
                         else
                           anime.genres
                         end

          anime.age_limit = material_data['minimal_age']
          anime.score = get_anime_score(shikimori_id) || material_data['shikimori_rating']
          anime.status = get_anime_status(shikimori_id) || material_data['anime_status']
          anime.rating_mpaa = material_data['rating_mpaa']&.downcase || ""

          anime.next_episode_at = get_anime_next_episode_at(shikimori_id) || material_data['next_episode_at']
          anime.studios = get_anime_studios(shikimori_id)
          anime.videos = get_anime_videos(shikimori_id)
          anime.duration = get_anime_duration(shikimori_id) || material_data['duration']

          anime.description = get_anime_description(shikimori_id) ||
                              material_data['description'] ||
                              material_data['anime_description']

          anime.material_data = material_data

          puts "✅ Saved anime: #{anime.title} (#{anime.title_orig}) | Score: #{anime.score}"
          anime.save
        end
      end
    rescue OpenURI::HTTPError => e
      puts "HTTP-ошибка: #{e.message}"
    rescue => e
      puts "Ошибка: #{e.message}"
    end
  end
end

def is_probably_chinese?(title_orig, other_titles_jp, studios = [], kind = nil, material_data = {})
  reasons = []

  chinese_studios = %w[
    Shanghai Animation Film Studio CCTV Animation Alpha Group Creative Power Entertaining
    Mingxing Animation Hongmeng Cartoon Fantawild Animation Light Chaser Animation Studios
    Pearl Studio Haoliners Animation League YHKT Entertainment L²Studio Wolf Smoke Studio
    Base FX Base Animation Original Force Animation Mili Pictures Worldwide Shanghai Hippo Animation
    Vasoon Animation Puzzle Animation Studio Sparkly Key Animation Rocen Digital 2:10 Animation
    Colored-Pencil Animation October Media B&T Studio Chengdu Coco Cartoon Sharefun Studio
    Imagi Animation Studios Wang Film Productions Tencent Penguin Pictures Shanghai Motion Magic
    Colored-Pencil Animation Design BigFireBird Animation B.CMAY PICTURES Paper Plane Animation Studio
    Pb Animation Co. Ltd. LAN Studio iQIYI Youku Wulifang Year Young Culture Tang Kirin Culture
    Guton Animation Studio Wawayu Animation Seven Stone Entertainment Hangzhou Qitong Dongman
  ]

  # Проверка японских символов (катакана или хирагана)
  has_japanese = ->(str) { str =~ /[\p{Hiragana}\p{Katakana}]/ }
  has_japanese_text = has_japanese.call(title_orig.to_s) || other_titles_jp.any?(&has_japanese)

  if has_japanese_text
    return [false, '✅ Обнаружена японская фонетика (хирагана/катакана) — считаем японским']
  end

  # Страна
  if material_data['countries']&.include?('Китай')
    reasons << '🇨🇳 Указана страна — Китай'
  end

  # Студия
  if (studios & chinese_studios).any?
    reasons << '🏭 Студия входит в список китайских'
  end

  # Пиньинь + ONA
  chinese_pinyin_keywords = %w[
    wang zuo shen yin douluo da lu xian wang wan jie mo dao zu shi tian guan
    yao shen ni tian xie wanmei shijie donghua xian xia juan siliang taigu zhan hun
  ]
  texts_to_check = [title_orig.to_s, *other_titles_jp.map(&:to_s)]
  joined = texts_to_check.map(&:downcase).join(' ')
  if kind == 'ona' && chinese_pinyin_keywords.any? { |kw| joined.include?(kw) }
    reasons << '🈸 ONA + найдено китайское пиньинь-слово'
  end

  if reasons.any?
    [true, reasons.join('; ')]
  else
    [false, '✅ Не найдено признаков китайского аниме']
  end
end

def worldart_url_poster(worldart_link)
  url = worldart_link
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)
  
  # Ищем тег <img> внутри блока, где размещён постер
  poster_img = doc.css('img').find do |img|
    img['src']&.include?('animation_poster')
  end
  
  if poster_img
    poster_url = "http://www.world-art.ru/#{poster_img['src']}"
    puts "Постер: #{poster_url}"
  else
    puts "Постер не найден"
  end
end

def contains_chinese?(text)
  !!(text =~ /[\u4E00-\u9FFF]/)
end

def cover_url(shikimori_id)
  "https://shikimori.one/system/animes/original/#{shikimori_id}.jpg"
end

def get_anime_status(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['status'] if response.is_a?(Net::HTTPSuccess)
end

def get_anime_description(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['description'] if response.is_a?(Net::HTTPSuccess)
end

def get_anime_duration(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['duration'] if response.is_a?(Net::HTTPSuccess)
end

def get_anime_videos(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['videos'] if response.is_a?(Net::HTTPSuccess)
end

def get_anime_studios(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['studios'] if response.is_a?(Net::HTTPSuccess)
end

def get_anime_next_episode_at(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['next_episode_at'] if response.is_a?(Net::HTTPSuccess)
end

def get_anime_score(shikimori_id)
  url = "https://shikimori.one/api/animes/#{shikimori_id}"
  response = Net::HTTP.get_response(URI(url))
  JSON.parse(response.body)['score'].to_f if response.is_a?(Net::HTTPSuccess)
end