class Decortile
	attr_accessor :id, :x, :y, :width, :height, :stretchlimit, :sbelow, :sabove, :sright, :sleft, :alwaysdraw
	def initialize(x, y, id, animlength, stretchlimit, layer, image)
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
		@stretchlimit = stretchlimit
		@write = "decor"
		@debug = Gosu::Font.new(6)
		@permlayer = layer
		@layer = @permlayer
		@sbelow = false
		@sabove = false
		@sright = false
		@sleft = false
		@alwaysdraw = false
		if @id == 51
			@alwaysdraw = true
			@spriteresetmax = 3
		end
	end
	
	def layering(playerx, playery)
		if @sbelow == true and @sabove == false and @sright == false and @sleft == false
			if playery > @y + @height
				@layer = 2
			else
				@layer = @permlayer
			end
		end
		if @sabove == true and @sbelow == false and @sright == false and @sleft == false
			if playery < @y
				@layer = 2
			else
				@layer = @permlayer
			end
		end
		if @sright == true and @sbelow == false and @sbelow == false and @sleft == false
			if playerx > @x + @width
				@layer = 2
			else
				@layer = @permlayer
			end
		end
		if @sleft == true and @sbelow == false and @sright == false and @sbelow == false
			if playerx < @x
				@layer = 2
			else
				@layer = @permlayer
			end
		end
	end
	
	def draw(playerx, playery)
		@tileimages[(@id + @sprite)].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @layer)
		if @id + @sprite >= @id and @id + @sprite < @id + @animlength
			if @spritereset >= @spriteresetmax
				@spritereset = 0
				@sprite += 1
			end
		end
		if @id + @sprite == @id + @animlength
			if @spritereset >= @spriteresetmax
				@spritereset = 0
				@sprite = 0
			end
		end


		if @spritereset <= @spriteresetmax - 1
			@spritereset += 1
		end

	end
end