require 'pagy/extras/overflow'

class ApplicationController < ActionController::API
  include Pagy::Backend
  
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Аниме не найдено' }, status: :not_found
  end

end

