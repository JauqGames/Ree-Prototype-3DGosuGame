class Stone
	attr_accessor :x, :y, :width, :height, :hits, :xvelocity, :yvelocity, :prehit, :aimdeg
	def initialize(x, y, xv, yv, aimdeg)
		@x = x
		@y = y
		@width = 2
		@height = 2
		@drawwidth = 8
		@drawheight = 8
		@hits = 0
		@image = Gosu::Image.new('img\stone.png')
		@xvelocity = xv * 5
		@yvelocity = yv * -5
		@prehit = "none"
		@stretchlimit = 14
		@color = 0xff_ffffff
		@aimdeg = aimdeg
	end
	
	def gravity
		@x += @xvelocity
		@y += @yvelocity
	end
	
	def draw(playerx, playery)
		@image.draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, 5)
	end
end