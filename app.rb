require "sinatra/base"
require "RMagick"
require "cgi"

class App < Sinatra::Base
  # /60x80/000/f00.png&text=hoge
  #   ^     ^   ^   ^    ^
  #   |     |   |   |     `- label (optional)
  #   |     |   |    `- format (optional, default: png)
  #   |     |    `- color (optional)
  #   |      `- bgcolor (optional)
  #    `- size(width x height) or width
  get %r{/(?<size>[0-9x]+)(?:/(?<bgcolor>[0-9a-fA-F]+)(?:/(?<color>[0-9a-fA-F]+))?)?(?:\.(?<format>[^\/.?]+))?(?:&text=(?<label>.*))?} do
    width, height = params[:size].split("x").map(&:to_i)
    height ||= width # if input width only
    bgcolor = params[:bgcolor] || "cccccc"
    color   = params[:color]   || "000000"
    label   = params[:label] ? CGI.unescape(params[:label]) : "#{width}x#{height}"
    format  = params[:format]  || "png"
    img = Magick::Image.new(width, height) {
      self.background_color = "##{bgcolor}"
    }
    Magick::Draw.new.annotate(img, 0, 0, 0, 0, label) do
      self.gravity = Magick::CenterGravity
      self.fill = "##{color}"
    end

    case format.to_sym
    when :jpg, :jpeg
      content_type 'image/jpeg'
      img.format = 'jpg'
    when :gif
      content_type 'image/gif'
      img.format = 'gif'
    else
      content_type 'image/png'
      img.format = 'png'
    end
    img.to_blob
  end
end
