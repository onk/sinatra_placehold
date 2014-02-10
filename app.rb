require "sinatra/base"
require "RMagick"

class App < Sinatra::Base
  get "/:size/?:bgcolor?/?:color?" do
    content_type 'image/png'
    width, height = params[:size].split("x").map(&:to_i)
    height ||= width # if input width only
    bgcolor = params[:bgcolor] || "cccccc"
    color = params[:color] || "000000"
    img = Magick::Image.new(width, height) {
      self.background_color = "##{bgcolor}"
    }
    Magick::Draw.new.annotate(img, 0, 0, 0, 0, "#{width}x#{height}") do
      self.gravity = Magick::CenterGravity
      self.fill = "##{color}"
    end

    img.format = 'png'
    img.to_blob
  end
end
