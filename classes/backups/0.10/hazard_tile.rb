class HazardTile
attr_accessor :id, :x, :y, :width, :height
	def initialize(x, y, id, animlength, layer, image)
		@x = x * 16
		@y = y * 16
		@width = 16
		@height = 16
		@id = id
		@sprite = 0
		@animlength = animlength - 1
		@spriteresetmax = 10
		@spritereset = @spriteresetmax
		@tileimages = image
		@color = Gosu::Color.argb(0xff_ffffff)
		@stretchlimit = 8
		@stretchlimit2 = 14
		@write = "hazard"
		@debug = Gosu::Font.new(6)
		@layer = layer * 5
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
		@tileimages[(@id + @sprite)].draw(@x - $xcamera, @y - $ycamera, 25 + @p)
		@tileimages[(@id + @sprite)].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @layer + @p - @aalayerx - @aalayery)
		@tileimages[(@id + @sprite)].draw_as_quad((((@x * (@stretchlimit2 - 1)) + playerx) / @stretchlimit2) - $xcamera, (((@y * (@stretchlimit2 - 1)) + playery) / @stretchlimit2) - $ycamera, @color, ((((@x + @width) * (@stretchlimit2 - 1)) + playerx) / @stretchlimit2) - $xcamera, (((@y * (@stretchlimit2 - 1)) + playery) / @stretchlimit2) - $ycamera, @color, (((@x * (@stretchlimit2 - 1)) + playerx) / @stretchlimit2) - $xcamera, ((((@y + @height) * (@stretchlimit2 - 1)) + playery) / @stretchlimit2) - $ycamera, @color, ((((@x + @width) * (@stretchlimit2 - 1)) + playerx) / @stretchlimit2) - $xcamera, ((((@y + @height) * (@stretchlimit2 - 1)) + playery) / @stretchlimit2) - $ycamera, @color, @layer + @p - @aalayerx - @aalayery)
		if @id + @sprite >= @id and @id + @sprite < @id + @animlength
			if @spritereset == @spriteresetmax
				@spritereset = 0
				@sprite += 1
			end
		end
		if @id + @sprite == @id + @animlength
			if @spritereset == @spriteresetmax
				@spritereset = 0
				@sprite = 0
			end
		end


		if @spritereset <= @spriteresetmax - 1
			@spritereset += 1
		end
		
		if $debugmode == true
			@debug.draw("#{@write}", @x - $xcamera, @y + 6 - $ycamera, 7)
		end

	end
end