require "sinatra/base"
require "RMagick"

class App < Sinatra::Base
  get '/:size' do
    content_type 'image/png'

    width, height = params[:size].split("x").map(&:to_i)
    img = Magick::Image.new(width, height) { self.background_color = "#cccccc" }
    Magick::Draw.new.annotate(img, 0, 0, 0, 0, "#{width}x#{height}") do
      self.gravity = Magick::CenterGravity
    end

    img.format = 'png'
    img.to_blob
  end
end
