#
# 2011/11/12
# author : Kentaro Doba
#

require "rubygems"
require "RMagick"

##  no arguments ?  ##
if ARGV.size <= 0
  print("set image name : 'ruby main.rb sample.jpg'\n")
  exit
end

##  check options  ##
user_size = 0
for i in 0..ARGV.size
  if "-rev" == ARGV[i] then is_reverse = true; end
  if "-size" == ARGV[i] then
    if i+1 < ARGV.size then user_size = ARGV[i+1].to_i; end
  end
end

##  load image  ##
img = Magick::ImageList.new(ARGV[0])
w = img.columns
h = img.rows

##  resize  ##
re_w = (user_size > 0) ? user_size : 50
re_h = (0.5 * re_w * h / w).to_i
img.resize!(re_w, re_h)


##  characters for display  ##
conc = [
" ", ".", "-", "=", "+", "*", "%", "@"
]
if is_reverse then conc = conc.reverse; end

##  coef for gray-scale conversion  ##
coef_r = 0.299
coef_g = 0.587
coef_b = 0.114

##  main process  ##
y = 0
while y < re_h
  x = 0
  while x < re_w
    pix = img.pixel_color(x,y)
    gray = coef_r * (pix.red>>8) + coef_g * (pix.green>>8) + coef_b * (pix.blue>>8)
    igray = (gray/32.0).to_i
    if(igray < 0) then igray = 0; end
    if(igray > 7) then igray = 7; end
    printf(conc[igray])
    x += 1
  end
  y += 1
  print("\n")
end
