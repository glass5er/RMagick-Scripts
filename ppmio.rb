

class PpmImg
  def initialize(w, h, c=1, v=255)
    @width = w
    @height = h
    @channel = c
    @vmax = v
    @data = create_buf(w,h,c)
  end

protected
  def self=(obj)
    @width = obj.width
    @height = obj.height
    @channel = obj.channel
    @vmax = obj.vmax
    @data = Marshal.load(Marshal,dump(obj.data))
  end

  def create_buf(ww,hh,cc)
    buf = Array.new(cc)
    cc.times{|c|
      buf[c] = Array.new(hh)
      hh.times{|y|
        buf[c][y] = Array.new(ww, 0)
      }
    }
    return buf
  end

public
  def PpmImg.read(filename)
    io = File.open(filename, "r")
    format = io.gets.chomp
    channel = format == "P6" ? 3 : 1
    str_w, str_h = io.gets.chomp.split(" ")
    width = str_w.to_i
    height = str_h.to_i
    vmax = io.gets.chomp.to_i
    dst = self.new(width, height, channel, vmax)
    valuearr = io.read.chomp.unpack('C*')
    #p valuearr
    itr = 0
    height.times{|y|
      width.times{|x|
        channel.times{|c|
          dst.setpixel(x,y,c,valuearr[itr].to_i)
          itr += 1
        }
      }
    }
    io.close
    return dst
  end


  def write(filename)
    io = File.open(filename, "w")
    format = @channel > 1 ? "P6" : "P5"
    io.print(format,"\n")
    io.print(@width, " ", @height, "\n")
    io.print(@vmax,"\n")
    itr = 0
    valuearr = []
    @height.times{|y|
      @width.times{|x|
        @channel.times{|c|
          valuearr[itr] = self.pixel(x,y,c)
          itr += 1
        }
      }
    }
    io.print(valuearr.pack('C*'))
    io.close
  end
  def pixel(x,y,c)
    return @data[c][y][x]
  end
  def setpixel(x,y,c,val)
    @data[c][y][x] = val
  end
end

# read
img = PpmImg.read("hoge.ppm")
# copy
fuga = img
# write
fuga.write("hoge2.ppm")
