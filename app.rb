require "sinatra/base"
require "RMagick"

class App < Sinatra::Base
  get '/' do
    content_type 'image/png'
    img = Magick::Image.read('logo:')[0]
    img.format = 'png'
    img.to_blob
  end
end
