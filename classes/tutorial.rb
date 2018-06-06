class Tutorial
	attr_accessor :rools
	def initialize(tools)
		@x = 0
		@y = 0
		@newx = 0
		@newy = 0
		@tools = tools
		@rools = {}
		@rools[:col] = Gosu::Color.argb(0x00_ffffff)
		@rools[:anum] = 0
		@has_image = false
		@subtract = false
		@image = @tools[0]
		@newimage = @tools[0]
		@p = 1000
	end
	
	def switch(x, y, image)
		@newx = x
		@newy = y
		if image == -1
			@switch = true
			@subtract = true
		else
			@switch = true
			@newimage = @tools[image]
			@has_image = true
			@subtract = false
		end
	end
	
	def draw
		if @has_image == true
			@rools[:col].alpha = @rools[:anum]
			@image.draw(@x, @y, @p + 35, 1, 1, @rools[:col])
			if @switch == true
				if @subtract == false
					if @image != @newimage
						if @rools[:anum] > 1
							@rools[:anum] = (@rools[:anum]/1.1).floor
						elsif @rools[:anum] > 0 and @rools[:anum] <= 1
							@rools[:anum] = 0
						elsif @rools[:anum] <= 0
							@image = @newimage
							@x = @newx
							@y = @newy
						end
					elsif @image == @newimage
						if @x != @newx
							@x = @newx
						end
						if @y != @newy
							@y = @newy
						end
						if @rools[:anum] < 254
							@rools[:anum] = ((255 - @rools[:anum]) * 0.1).floor + @rools[:anum]
						elsif @rools[:anum] >= 254 and @rools[:anum] < 255
							@rools[:anum] = 255
						elsif @rools[:anum] >= 255
							@switch = false
						end
					end
				else
					if @rools[:anum] > 1
						@rools[:anum] = (@rools[:anum]/1.1).floor
					elsif @rools[:anum] > 0 and @rools[:anum] <= 1
						@rools[:anum] = 0
					elsif @rools[:anum] <= 0
						@image = @newimage
						@x = @newx
						@y = @newy
						@switch = false
						@subtract = false
						@has_image = false
					end
				end
			end
		end
	end
end