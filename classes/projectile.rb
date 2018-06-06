class Projectile
	attr_accessor :x, :y, :width, :height, :hits, :xvelocity, :yvelocity, :prehit, :aimdeg
	def initialize(x, y, xv, yv, aimdeg, map, id)
		@x = x
		@y = y
		@width = 2
		@height = 2
		@drawwidth = 8
		@drawheight = 8
		@hits = 0
		@image = map
		@id = id
		@xvelocity = xv
		@yvelocity = yv
		@prehit = "none"
		@stretchlimit = 14
		@color = 0xff_ffffff
		@aimdeg = aimdeg
		@autoadjustlayer = true
		@p = 1000
		@aalayerx = 0
		@aalayery = 0
	end
	
	def gravity
		@x += @xvelocity
		@y += @yvelocity
	end
	
	def draw(playerx, playery)
		if @autoadjustlayer == true
			@aalayerx = ((@x / 16).round - (playerx / 16).round).abs
			@aalayery = ((@y / 16).round - (playery / 16).round).abs
			@p = 1000
		else
			@aalayerx = 0
			@aalayery = 0
			@p = 0
		end
		@image[@id].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, 25 + @p - @aalayerx - @aalayery)
	end
end