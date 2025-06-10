set :output, 'log/cron.log'

every 2.hours do
  command "cd /Users/air/Ruby_Home/AnimeApp3 && /Users/air/.rbenv/shims/bundle exec rake parse_anime:parse_data RAILS_ENV=production"
end
