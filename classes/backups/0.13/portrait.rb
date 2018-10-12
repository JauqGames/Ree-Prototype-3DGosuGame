class Portrait
	def initialize (x, y)
		@x = x
		@y = y
		@image = Gosu::Image.new('img\portrait.png')
		@imagecl = Gosu::Image.new('img\portraitcl.png')
		@imagetc = Gosu::Image.new('img\portraittc.png')
		@imagest = Gosu::Image.new('img\portraitst.png')
		@p = 1000
	end
	
	def draw
		@image.draw(@x, @y, 35 + @p)
		@imagecl.draw(@x, @y, 35 + @p, 1, 1, $colorswitch)
		@imagetc.draw(@x, @y, 35 + @p, 1, 1, $colorswitch3)
		@imagest.draw(@x, @y, 35 + @p, 1, 1, $colorswitch2)
	end
end