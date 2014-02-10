require "sinatra/base"
require "RMagick"
require "cgi"

class App < Sinatra::Base
  # /60x80/000/f00&text=hoge
  #   ^     ^   ^       ^
  #   |     |   |       |
  #   |     |   |        `- label (optional)
  #   |     |    `- color (optional)
  #   |      `- bgcolor (optional)
  #    `-size (width x height) or width
  get %r{/(?<size>[0-9x]+)/?(?<bgcolor>[0-9a-fA-F]+)?/?(?<color>[0-9a-fA-F]+)?(&text=)?(?<text>.*)?} do
    content_type 'image/png'
    width, height = params[:size].split("x").map(&:to_i)
    height ||= width # if input width only
    bgcolor = params[:bgcolor] || "cccccc"
    color   = params[:color]   || "000000"
    text    = params[:text] ? CGI.unescape(params[:text]) : "#{width}x#{height}"
    img = Magick::Image.new(width, height) {
      self.background_color = "##{bgcolor}"
    }
    Magick::Draw.new.annotate(img, 0, 0, 0, 0, text) do
      self.gravity = Magick::CenterGravity
      self.fill = "##{color}"
    end

    img.format = 'png'
    img.to_blob
  end
end
