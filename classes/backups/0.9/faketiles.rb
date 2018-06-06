class Faketiles
	attr_accessor :id, :x, :y, :width, :height, :transparency, :vanish, :color
	def initialize(id, x, y, width, height)
		@id = id
		@x = x * 16 + 4
		@y = y * 16 + 4
		@width = width * 16 - 8
		@height = height * 16 - 8
		@transparency = 255
		@vanish = false
		@color = Gosu::Color.argb(0xff_ffffff)
		if @id == "g1"
			@image = Gosu::Image.new('img\fwgreen1.png')
		elsif @id == "g2"
			@image = Gosu::Image.new('img\fwgreen2.png')
		elsif @id == "g3"
			@image = Gosu::Image.new('img\fwgreen3.png')
		elsif @id == "g4"
			@image = Gosu::Image.new('img\fwgreen4.png')
		end
	end
	
	def draw
		@image.draw(@x - 4 - $xcamera, @y - 4 - $ycamera, 6, 1, 1, @color)
	end
	
	def update
		if @vanish == true 														#needs to be reversed
			if @transparency > 0.1
				@color.alpha = @transparency
				@transparency = @transparency - (@transparency / 1.05)
			elsif @transparency <= 0.1 and @transparency > 0
				@color.alpha = @transparency
				@transparency = 0
			end
		end
	end
end