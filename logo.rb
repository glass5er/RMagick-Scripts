#
# 2011/12/19
# author : Kentaro Doba
#

require "rubygems"
require "RMagick"

##  create image  ##
img = Magick::ImageList.new()
w = 400
h = 100
bgcolor = "gray95"
fgcolor = "skyblue"
img.new_image(w,h){
  self.background_color = bgcolor
}

logo = Magick::Draw.new
logo.pointsize = 50
text = "hogehoge"

text_w = 0
text_h = 0
start_x = 80
start_y = 65

## broad shape ##
logo.annotate(img, text_w, text_h, start_x, start_y, text) {
  self.fill = fgcolor
  self.font_weight = Magick::BoldWeight
}

## blur ##
img = img.blur_image(0.0, 4.0)

## detailed shape ##
logo.annotate(img, text_w, text_h, start_x, start_y, text) {
  self.fill = fgcolor
  self.font_weight = Magick::BoldWeight
}

## blur ##
img = img.blur_image(0.0, 2.0)

## blanking ##
logo.annotate(img, text_w, text_h, start_x, start_y, text) {
  self.fill = bgcolor
  self.font_weight = Magick::BoldWeight
}

img.write("out.png")

