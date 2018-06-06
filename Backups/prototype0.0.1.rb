
	require 'gosu'
	
	#Layer Data
		#5 = Tiles
		#4 = Player
		
	#Notes
		#@image = Gosu::Image.load_tiles('tiles.png', @width, @height)
		#@image.count = gives count of images
	
class GameWindow < Gosu::Window

	def initialize()
		super(196, 160)
		self.caption = ("Simplist Game")
		self.fullscreen = true
		Gosu::enable_undocumented_retrofication
		
		$xcamera = 0
		$ycamera = 0
		@load = 1
		$gravity = 0.3
		
		@tilemap = []
		@player = Player.new(3, 6)
		@debug = Gosu::Font.new(20)
	end
	
	def placetile(x, y, id)
		@tilemap.push(Tile.new(x, y, id))
	end
	
	def update
		if @load == 1
		
			if true
				placetile(0, 0, 14)
				placetile(1, 0, 6)
				placetile(0, 1, 7)
				placetile(0, 2, 7)
				placetile(0, 3, 7)
				placetile(0, 4, 7)
				placetile(0, 5, 7)
				placetile(0, 6, 7)
				placetile(0, 7, 7)
				placetile(0, 8, 15)
				placetile(1, 8, 8)
				placetile(1, 9, 15)
				placetile(2, 9, 4)
				placetile(3, 9, 4)
				placetile(4, 9, 12)
				placetile(4, 8, 5)
				
				@load = 2
			end
			
		elsif @load == 2
			
			if  button_down?(Gosu::KbRight)
				@player.movement("right")
			elsif button_down?(Gosu::KbLeft)
				@player.movement("left")
			else
				if @player.jumped == false
					@player.not_moving
				end
			end
			if button_down?(Gosu::KbUp)
				if @player.bottcoll == true and @player.jumped == false
					@player.jump
				end
			end
			
			@tilemap.each do |tile|
				if rightzone(@player, tile)
					if righthit(@player, tile)
						@player.leftcoll = true
					else
						@player.leftcoll = false
					end
				else

				end
				if leftzone(@player, tile)
					if lefthit(@player, tile)
						@player.rightcoll = true
					else 
						@player.rightcoll = false
					end
				else
					@player.rightcoll = false
				end
				if topzone(@player, tile)
					if tophit(@player, tile)
						@player.bottcoll = true
						@player.jumped = false
						@player.standon(tile.y)
					else
						@player.bottcoll = false
					end
				else

				end
				
			end
			
			$xcamera = (@player.x + 5) - 98
			$ycamera = (@player.y + 7) - 80
			
			if @player.bottcoll == false
				@player.gravity
			end
			
		end
	end
	
	def draw
		@tilemap.each do |tile|
			tile.draw
		end
		@player.draw
		@debug.draw("#{@player.rightcoll}", 0, 0, 7)
		@debug.draw("#{@player.leftcoll}", 0, 20, 7)
		@debug.draw("#{@player.bottcoll}", 0, 40, 7)
	end
	
	def righthit(a, b)
		a.x <= b.x + b.width and a.y < b.y + b.height and a.y + a.height > b.y and not a.x + a.width < b.x
	end
	
	def rightzone(a, b)
		a.x > b.x + b.width - 15 and a.x < b.x + b.width + 15 and a.y < b.y + b.height and a.y + a.height > b.y
	end
	
	def lefthit(a, b)
		a.x + a.width >= b.x and a.y < b.y + b.height and a.y + a.height > b.y and not a.x > b.x + b.width
	end
	
	def leftzone(a, b)
		a.x + a.width > b.x - 15 and a.x + a.width < b.x + 15 and a.y < b.y + b.height and a.y + a.height > b.y
	end

	def bottomhit(a, b)
		a.y <= b.y + b.height and a.x < b.x + b.width and a.x + a.width > b.x and not a.y < b.y
	end
	
	def bottomzone(a, b)
		a.y > b.y + b.height - 15 and a.y < b.y + b.height + 15 and a.x < b.x + b.width and a.x + a.width > b.x
	end
	
	def tophit(a, b)
		a.y + a.height >= b.y and a.x < b.x + b.width and a.x + a.width > b.x and not a.y > b.y + b.height
	end
	
	def topzone(a, b)
		a.y + a.height > b.y - 15 and a.y + a.height < b.y + 15 and a.x < b.x + b.width and a.x + a.width > b.x
	end
	
	def button_down(id)
		if id == Gosu::KbEscape
			self.close
		end
	end
end

class Tile
	attr_reader :id, :x, :y, :width, :height
	def initialize(x, y, id)
		@x = x * 16
		@y = y * 16
		@width = 16
		@height = 16
		@id = id
		@tileimages = Gosu::Image.load_tiles('tiles.png', 16, 16)
	end
	
	def draw
		@tileimages[@id].draw(@x - $xcamera, @y - $ycamera, 5)
	end
end

class Player
	attr_accessor :x, :y, :width, :height, :facing, :jumped, :moving, :leftcoll, :rightcoll, :bottcoll, :topcoll
	def initialize(x, y)
		@x = x * 16
		@y = y * 16
		@prex = x
		@prey = y
		@width = 10
		@height = 14
		@speed = 2
		@jumpvelocity = 4.0
		@yvelocity = 0
		@spritesheet = Gosu::Image.load_tiles('prototypeplayer.png', 16, 16)
		@sprite = 2
		@spriteresetmax = 10
		@spritereset = @spriteresetmax
		@facing = "right"
		@jumped = false
		@moving = false
		@leftcoll = false
		@rightcoll = false
		@bottcoll = false
		@topcoll = false
	end
	
	def movement(button)
		if button == "right"
			if @rightcoll == false
				@prex = @x
				@x += @speed
				@moving = true
				@facing = "right"
				if @sprite < 6 or @sprite > 11
					@sprite = 6
				end
			end
		elsif button == "left"
			if @leftcoll == false
				@x -= @speed
				@moving = true
				@facing = "left"
				if @sprite < 6 or @sprite > 11
					@sprite = 6
				end
			end
		end
	end
	
	def not_moving
		@moving = false
		if @sprite < 2 or @sprite > 5
			@sprite = 2
		end
	end
	
	def jump
		@y -= @jumpvelocity
		@yvelocity -= @jumpvelocity
		@jumped = true
		@bottcoll = false
	end

	def standon(tiley)
		@yvelocity = 0
		@prey = tiley - @height
		@y = @prey
		@prey = nil
	end
	
	def gravity
		@yvelocity += $gravity
		@y += @yvelocity
	end
	
	def draw
		if facing == "right"
			if @jumped == false
				if @moving == false
					if @sprite >= 2 and @sprite <= 4
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						elsif @spritereset <= 1
						end
					elsif @sprite == 5
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 2
						elsif @spritereset <= 1
						end
					end
				elsif @moving == true
					if @sprite >= 6 and @sprite <= 10
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						elsif @spritereset <= 1
						end
					elsif @sprite == 11
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 6
						elsif @spritereset <= 1
						end
					end
				end
			elsif @jumped == true
			end
			
			@spritesheet[@sprite].draw(@x - $xcamera - 3, @y - $ycamera - 2, 4)
			
		elsif facing == "left"
			if @jumped == false
				if @moving == false
					if @sprite >= 2 and @sprite <= 4
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						elsif @spritereset <= 1
						end
					elsif @sprite == 5
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 2
						elsif @spritereset <= 1
						end
					end
				elsif @moving == true
					if @sprite >= 6 and @sprite <= 10
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						elsif @spritereset <= 1
						end
					elsif @sprite == 11
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 6
						elsif @spritereset <= 1
						end
					end
				end
			elsif @jumped == true
			end
			
			@spritesheet[@sprite].draw(@x - $xcamera + 16 - 3, @y - $ycamera - 2, 4, -1.0, 1.0)
			
		end
		
		if @spritereset <= @spriteresetmax - 1
			@spritereset += 1
		end
	end
end

window = GameWindow.new
window.show
