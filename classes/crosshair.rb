class Crosshair
	attr_accessor :x, :y, :id
	def initialize
		@x = -1000
		@y = -1000
		@image = Gosu::Image.new('img\crosshair.png')
		@aim = 0
		@p = 1000
	end
	
	def draw
		@image.draw_rot(@x - $xcamera, @y - $ycamera, 30 + @p, @aim)
	end
	
	def rotate(aim)
		@aim = aim
	end
	
	def move(x, y)
		@x = x
		@y = y
	end
end