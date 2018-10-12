class Button
	attr_accessor :x, :y, :width, :height, :condition
	def initialize(x, y, condition)
		@x = (x * 16) + 2
		@y = (y * 16) + 2
		@width = 12
		@height = 12
		@drawwidth = 12
		@drawheight = 12
		@condition = condition
		@image = Gosu::Image.new('img\swik.png')
		@stretchlimit = 14
		@color = 0x80_9f9f9f
		@autoadjustlayer = true
		@p = 1000
		@aalayerx = 0
		@aalayery = 0
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
		@image.draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 25 + @p - @aalayerx - @aalayery)
		if $conditions[condition] == 0
			@color = 0x80_9f9f9f
		elsif $conditions[condition] > 0
			@color = 0xc0_ffffff
		end	
	end
end