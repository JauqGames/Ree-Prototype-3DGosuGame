class Portrait
	def initialize (x, y)
		@x = x
		@y = y
		@image = Gosu::Image.new('img\portrait.png')
		@imagecl = Gosu::Image.new('img\portraitcl.png')
		@imagetc = Gosu::Image.new('img\portraittc.png')
		@imagest = Gosu::Image.new('img\portraitst.png')
	end
	
	def draw
		@image.draw(@x, @y, 7)
		@imagecl.draw(@x, @y, 7, 1, 1, $colorswitch)
		@imagetc.draw(@x, @y, 7, 1, 1, $colorswitch3)
		@imagest.draw(@x, @y, 7, 1, 1, $colorswitch2)
	end
end