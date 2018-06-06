class VisualGem
	attr_accessor
	def initialize(x, y, id = 0, type, sprites)
		@x = x * 16
		@y = y * 16
		@ax = @x
		@ay = @y
		@width = 20
		@height = 20
		@drawwidth = 20
		@drawheight = 20
		@image = sprites
		@stretchlimit = 14
		@color = 0xff_ffffff
		@id = id * 11
		@sprite = 0
		@spritereset = 0
		@spriteresetmax = 2
		@type = type
	end
	
	def draw(playerx, playery)
		if @spritereset < @spriteresetmax
			@spritereset += 1
		elsif @spritereset >= @spriteresetmax
			@sprite += 1
			@spritereset = 0
			if @sprite >= 11
				@sprite = 0
				@spritereset = -80 + (@id * -8)
			end
		end
		@image[@id + @sprite].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, 5)		
	end
end