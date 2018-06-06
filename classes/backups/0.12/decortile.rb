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
		@autoadjustlayer = true
		@p = 1000
		@d = 0
		@aalayerx = 0
		@aalayery = 0
	end
	
	def layering(playerx, playery)
		@layer = @permlayer * 5
		if @sbelow == true and @sabove == false and @sright == false and @sleft == false
			if playery > @y + @height
				@layer = 10
			else
				@layer = @permlayer * 5
			end
		end
		if @sabove == true and @sbelow == false and @sright == false and @sleft == false
			if playery < @y
				@layer = 10
			else
				@layer = @permlayer * 5
			end
		end
		if @sright == true and @sbelow == false and @sbelow == false and @sleft == false
			if playerx > @x + @width
				@layer = 10
			else
				@layer = @permlayer * 5
			end
		end
		if @sleft == true and @sbelow == false and @sright == false and @sbelow == false
			if playerx < @x
				@layer = 10
			else
				@layer = @permlayer * 5
			end
		end
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
		if @permlayer == 4
			@d = 5
		else
			@d = 0
		end
		@tileimages[(@id + @sprite)].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @layer + @d + @p - @aalayerx - @aalayery)
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
=begin
		if @stretchlimit == 17
			@debug.draw("#{@x / 16}", @x - $xcamera, @y - $ycamera, 80000)
			@debug.draw("#{@y / 16}", @x - $xcamera, @y - $ycamera + 7, 80000)
		end
=end
		if @spritereset <= @spriteresetmax - 1
			@spritereset += 1
		end

	end
end