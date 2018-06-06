
	require 'gosu'
	
	#Layer Data
		#7 = Debug Numbers
		#6 = Fake Tiles
		#5 = Tiles
		#4 = Player
		#3 = 3D Tiles
		#2 = Rear Tiles
		#0 = Far BG
		
	#Notes
		#@image = Gosu::Image.load_tiles('tiles.png', @width, @height)
		#@image.count = gives count of images
	
class GameWindow < Gosu::Window

	def initialize()
		@screensizeadjust = 0
		super(196 + @screensizeadjust, 160 + @screensizeadjust)
		self.caption = ("Simplest Game")
		@fullscreen = false
		self.fullscreen = @fullscreen
		Gosu::enable_undocumented_retrofication
		
		$xcamera = 0
		$ycamera = 0
		@load = 1.0
		$gravity = 0.2
		$debugmode = false
		$playerhealth = 5
		
		$tilesimage = Gosu::Image.load_tiles('green_tiles.png', 16, 16)
		@bg = Gosu::Image.new("greenbg.png")
		
		@solidtilemap = []
		@platformtilemap = []
		@airtilemap = []
		@decortilemap = []
		@faketilesmap = []
		@player = Player.new(3, 6)
		@player_aim_dummy = PlayerAimDummy.new
		@portrait = Portrait.new(0, 0)
		@debug = Gosu::Font.new(8)
		@genx = 0
		@geny = 0
		@genz = 0
		@build_dizzy = 0
		@tile_to_right = 0
		@tile_to_left = 0
		@tile_to_top = 0
		@tile_to_bottom = 0
		
		@hpdarray = []
		5.times do |count|
			if count == 0
				@hpdarray.push(Hpd.new(21, 12, count))
			elsif count == 1
				@hpdarray.push(Hpd.new(27, 6, count))
			elsif count == 2
				@hpdarray.push(Hpd.new(33, 12, count))
			elsif count == 3
				@hpdarray.push(Hpd.new(39, 6, count))
			elsif count == 4
				@hpdarray.push(Hpd.new(45, 12, count))
			end
		end
		@crosshairarray = []
		3.times do |count|
			@crosshairarray.push(Crosshair.new(count + 1))
		end
	end
	
	def placesolidtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write)
		@solidtilemap.push(Tile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write))
	end
	def placeplatformtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write)
		@platformtilemap.push(Tile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write))
	end
	def placeairtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write)
		@airtilemap.push(Tile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write))
	end
	def placedecortile(x, y, id, animlength, stretchlimit, layer)
		@decortilemap.push(Decortile.new(x, y, id, animlength, stretchlimit, layer))
	end
	def placefaketiles(id, x, y, width, height)
		@faketilesmap.push(Faketiles.new(id, x, y, width, height))
	end
	
	def generate_default_tiles(x, y, width, height, id)
		(width * height).times do
			placesolidtile(@genx + x, @geny + y, id, 0, 0, 0, 0, 0, false, "solid")
			@genx += 1
			if @genx + x >= width
				@genx = 0
				@geny += 1
			end
			if @geny + y >= height and @genx + x >= width
				@genx = 0
				@geny = 0
				@build_dizzy += 1
			end
		end
	end
	def build_rectangle(x, y, width, height) 									#destructive
		@genx = 0
		@geny = 0
		(width * height).times do
			@airtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (@geny * 16) + (y * 16) 
					@airtilemap.delete tile
				end
			end
			@solidtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (@geny * 16) + (y * 16)
					@solidtilemap.delete tile
				end
			end
			@platformtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (@geny * 16) + (y * 16)
					@platformtilemap.delete tile
				end
			end
			@genx += 1
			if @genx >= width
				@genx = 0
				@geny += 1
			end
			if @geny >= height and @genx >= width
				@genx = 0
				@geny = 0
			end
		end
		@genx = 0
		@geny = 0
		((width) * (height)).times do
			placesolidtile(x + @genx, y + @geny, 0, 0, 0, 0, 0, 0, false, "solid")
			@genx += 1
			if @genx >= width
				@genx = 0
				@geny += 1
			end	
			if @geny >= height and @genx >= width
				@genx = 0
				@geny = 0
			end
		end
	end
	def build_background(x, y, width, height)										#destructive
		@genx = 0
		@geny = 0
		(width * height).times do
			@airtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (@geny * 16) + (y * 16) 
					@airtilemap.delete tile
				end
			end
			@solidtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (@geny * 16) + (y * 16)
					@solidtilemap.delete tile
				end
			end
			@platformtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (@geny * 16) + (y * 16)
					@platformtilemap.delete tile
				end
			end
			@genx += 1
			if @genx >= width
				@genx = 0
				@geny += 1
			end
			if @geny >= height and @genx >= width
				@genx = 0
				@geny = 0
			end
		end
		@genx = 0
		@geny = 0
		((width) * (height)).times do
			placeairtile(x + @genx, y + @geny, 0, 0, 0, 0, 0, 0, false, "air")
			@genx += 1
			if @genx >= width
				@genx = 0
				@geny += 1
			end	
			if @geny >= height and @genx >= width
				@genx = 0
				@geny = 0
			end
		end
	end
	def place_platform(x, y, width, id) 											#additive
		placeplatformtile(x, y, id, 0, 0, 15, 0, 0, true, "plat")
		placeplatformtile(x + width - 1, y, id, 0, 0, 17, 0, 0, true, "plat")
		(width - 2).times do |z|
			placeplatformtile((x + 1 + z), y, id, 0, 0, 16, 0, 0, true, "plat")
			z += 1
		end
	end
	def format_tiles
		@solidtilemap.each do |tile|
			@tile_to_bottom = 0
			@tile_to_left = 0
			@tile_to_right = 0
			@tile_to_top = 0
			@solidtilemap.each do |subtile|
				if tile.x - 16 == subtile.x and tile.y == subtile.y
					@tile_to_left = 1
				end
				if tile.x + 16 == subtile.x and tile.y == subtile.y
					@tile_to_right = 1
				end
				if tile.y - 16 == subtile.y and tile.x == subtile.x
					@tile_to_top = 1
				end
				if tile.y + 16 == subtile.y and tile.x == subtile.x
					@tile_to_bottom = 1
				end
			end
			if @tile_to_bottom == 0
				tile.bid = 7
			end
			if @tile_to_left == 0
				if @tile_to_top == 0
					tile.lid = 3
				elsif @tile_to_top == 1
					tile.lid = 6
				end
			end
			if @tile_to_right == 0
				if @tile_to_top == 0
					tile.rid = 5
				elsif @tile_to_top == 1
					tile.rid = 8
				end
			end
			if @tile_to_top == 0
				tile.tid = 4
			end
			
			if @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 0
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 0
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 0
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 0
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 1
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 0
				tile.id = 14
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 0
				tile.id = 12
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 1
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 0
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 1
				tile.id = 11
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 9
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 0
				tile.id = 13
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 1
				tile.id = 14
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 12
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 10
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 7
			end
		end
		@airtilemap.each do |tile|
			@tile_to_bottom = 0
			@tile_to_left = 0
			@tile_to_right = 0
			@tile_to_top = 0
			@solidtilemap.each do |subtile|
				if tile.x - 16 == subtile.x and tile.y == subtile.y
					@tile_to_left = 1
				end
				if tile.x + 16 == subtile.x and tile.y == subtile.y
					@tile_to_right = 1
				end
				if tile.y - 16 == subtile.y and tile.x == subtile.x
					@tile_to_top = 1
				end
				if tile.y + 16 == subtile.y and tile.x == subtile.x
					@tile_to_bottom = 1
				end
			end
			if @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 0
				tile.nid = 13
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 0
				tile.nid = 10
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 0
				tile.nid = 12
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 0
				tile.nid = 14
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 1
				tile.nid = 13
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 0
				tile.nid = 9
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 0
				tile.nid = 11
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 1
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 0
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 1
				tile.nid = 12
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.nid = 14
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 0
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 1
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 1
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 1
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 1
			end
		end
	end
	def replace_tile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type) 			#destructive
		@airtilemap.each do |tile|
			if tile.x == (x * 16) and tile.y == (y * 16) 
				@airtilemap.delete tile
			end
		end
		@solidtilemap.each do |tile|
			if tile.x == (x * 16) and tile.y == (y * 16)
				@solidtilemap.delete tile
			end
		end
		@platformtilemap.each do |tile|
			if tile.x == (x * 16) and tile.y == (y * 16)
				@platformtilemap.delete tile
			end
		end
		if type == "solid"
			placesolidtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type)
		elsif type == "air"
			placeairtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type)
		elsif type == "platform"
			placeplatformtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type)
		end
	end
	
	def update
		if @load == 1.0
		
			generate_default_tiles(-7, -7, 74, 49, 7)

			build_background(1, 2, 5, 4)
			build_background(3, 6, 3, 2)
			place_platform(3, 6, 3, 18)
			build_background(6, 2, 10, 3)
			build_background(16, 1, 9, 3)
			build_background(18, 4, 7, 14)
			place_platform(18, 4, 2, 18)
			build_background(1, 14, 17, 4)
			build_background(12, 18, 5, 3)
			place_platform(13, 16, 3, 18)
			build_background(1, 18, 6, 10)
			place_platform(5, 18, 2, 18)
			build_background(7, 25, 31, 3)
			build_background(13, 28, 4, 3)
			build_background(21, 28, 12, 3)
			place_platform(23, 28, 3, 18)
			place_platform(28, 28, 3, 18)
			build_background(30, 20, 8, 5)
			build_rectangle(30, 23, 4, 2)
			build_background(30, 13, 3, 7)
			build_background(33, 13, 11, 4)
			build_background(34, 4, 6, 9)
			build_rectangle(36, 11, 2, 2)
			build_background(40, 17, 4, 13)
			place_platform(36, 26, 2, 18)
			place_platform(36, 24, 2, 18)
			place_platform(30, 21, 2, 18)
			place_platform(30, 19, 2, 18)
			place_platform(31, 17, 2, 18)
			place_platform(34, 15, 2, 18)
			place_platform(34, 13, 2, 18)
			place_platform(34, 11, 2, 18)
			place_platform(40, 25, 4, 18)
			build_background(44, 22, 6, 3)
			build_background(49, 3, 10, 8)
			build_background(50, 11, 8, 14)
			build_background(28, 7, 4, 3)
			build_background(32, 9, 2, 1)
			
			format_tiles
			
			placedecortile(1, 5, 30, 1, 7, 3)
			placedecortile(2, 5, 33, 1, 7, 3)
			placedecortile(1, 5, 33, 1, 8, 3)
			placedecortile(3, 7, 30, 1, 7, 3)
			placedecortile(4, 7, 31, 1, 7, 3)
			placedecortile(5, 7, 32, 1, 7, 3)
			placedecortile(3, 7, 31, 1, 8, 3)
			placedecortile(4, 7, 31, 1, 8, 3)
			placedecortile(5, 7, 31, 1, 8, 3)
			placedecortile(3, 7, 31, 1, 17, 4)
			placedecortile(4, 7, 31, 1, 17, 4)
			placedecortile(5, 7, 31, 1, 17, 4)
			placedecortile(15, 4, 31, 1, 7, 3)
			placedecortile(14, 4, 31, 1, 7, 3)
			placedecortile(13, 4, 31, 1, 7, 3)
			placedecortile(12, 4, 34, 1, 7, 3)
			placedecortile(15, 4, 31, 1, 8, 3)
			placedecortile(14, 4, 34, 1, 8, 3)
			placedecortile(9, 4, 34, 1, 7, 3)
			placedecortile(10, 4, 33, 1, 7, 3)
			placedecortile(15, 4, 34, 1, 17, 4)
			placedecortile(24, 17, 26, 1, 7, 3)
			placedecortile(23, 17, 26, 1, 7, 3)
			placedecortile(22, 17, 35, 1, 7, 3)
			placedecortile(21, 17, 32, 1, 7, 3)
			placedecortile(20, 17, 34, 1, 7, 3)
			placedecortile(24, 16, 32, 1, 7, 3)
			placedecortile(23, 16, 34, 1, 7, 3)
			placedecortile(24, 17, 26, 1, 8, 3)
			placedecortile(23, 17, 35, 1, 8, 3)
			placedecortile(22, 17, 32, 1, 8, 3)
			placedecortile(21, 17, 34, 1, 8, 3)
			placedecortile(24, 16, 34, 1, 8, 3)
			placedecortile(24, 17, 35, 1, 10, 3)
			placedecortile(23, 17, 32, 1, 10, 3)
			placedecortile(22, 17, 31, 1, 10, 3)
			placedecortile(21, 17, 34, 1, 10, 3)		
			placedecortile(24, 17, 32, 1, 17, 4)
			placedecortile(23, 17, 31, 1, 17, 4)
			placedecortile(8, 17, 34, 1, 7, 3)
			placedecortile(9, 17, 31, 1, 7, 3)
			placedecortile(10, 17, 33, 1, 7, 3)	
			placedecortile(37, 27, 32, 1, 7, 3)
			placedecortile(36, 27, 31, 1, 7, 3)
			placedecortile(35, 27, 34, 1, 7, 3)
			placedecortile(37, 27, 34, 1, 8, 3)			
			placedecortile(1, 27, 35, 1, 7, 3)
			placedecortile(2, 27, 30, 1, 7, 3)
			placedecortile(3, 27, 31, 1, 7, 3)
			placedecortile(4, 27, 33, 1, 7, 3)
			placedecortile(1, 27, 30, 1, 8, 3)
			placedecortile(2, 27, 33, 1, 8, 3)
			placedecortile(1, 27, 33, 1, 10, 3)
			25.times do |z|
				if z >= 0 and z <= 3
					placedecortile(3 + (4 * z), 3, 21, 3, 7, 3)
					replace_tile(3 + (4 * z), 3, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 4 and z <= 9
					placedecortile(3 + (4 * (z - 4)), 15, 21, 3, 7, 3)
					replace_tile(3 + (4 * (z - 4)), 15, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 10 and z <= 17
					placedecortile(3 + (4 * (z - 10)), 26, 21, 3, 7, 3)
					replace_tile(3 + (4 * (z - 10)), 26, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 18 and z <= 20
					placedecortile(32 + (4 * (z - 18)), 15, 21, 3, 7, 3)
					replace_tile(32 + (4 * (z - 18)), 15, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 21 and z <= 24
					placedecortile(42 + (4 * (z - 21)), 23, 21, 3, 7, 3)
					replace_tile(42 + (4 * (z - 21)), 23, 0, 0, 0, 0, 0, 24, false, "air")
				end
			end
			
			3.times do |subz|
				replace_tile(2 + subz, 4, 0, 0, 0, 0, 0, 27 + subz, false, "air")
			end
			
			replace_tile(32, 21, 0, 0, 0, 0, 0, 27, false, "air")
			replace_tile(33, 21, 0, 0, 0, 0, 0, 28, false, "air")
			replace_tile(34, 21, 0, 0, 0, 0, 0, 28, false, "air")
			replace_tile(35, 21, 0, 0, 0, 0, 0, 28, false, "air")
			replace_tile(36, 21, 0, 0, 0, 0, 0, 29, false, "air")
			
			15.times do |z|
				if z >= 0 and z <= 1
					replace_tile(5 + (4 * z), 3, 0, 0, 0, 0, 0, 25, false, "air")
				elsif z >= 2 and z <= 6
					replace_tile(5 + (4 * (z - 2)), 15, 0, 0, 0, 0, 0, 25, false, "air")
				elsif z >= 7 and z <= 14
					replace_tile(5 + (4 * (z - 7)), 26, 0, 0, 0, 0, 0, 25, false, "air")
				end
			end
			
			placefaketiles("g1", 27, 6, 7, 5)

			@load = 2.0
			
		elsif @load == 2.0
			
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
						@player.leftcoll = false
						@player.rightcoll = false
						@player.bottcoll = false
						@player.below = false
			@solidtilemap.each do |tile|

				if a_is_left_of_b(@player, tile)
					if a_hits_left_of_b(@player, tile)
						@player.rightcoll = true
						if @player.bottcoll == true
							if @player.sprite < 2 or @player.sprite > 5
								@player.sprite = 2
								@player.moving = false
							end
						end
					else
						@player.rightcoll = false
					end
				end
				if a_is_right_of_b(@player, tile)
					if a_hits_right_of_b(@player, tile)
						@player.leftcoll = true
						if @player.bottcoll == true
							if @player.sprite < 2 or @player.sprite > 5
								@player.sprite = 2
								@player.moving = false
							end
						end
					else
						@player.leftcoll = false
					end
				end
				if a_is_above_b(@player, tile)
					if a_hits_top_of_b(@player, tile)
						@player.bottcoll = true
						@player.jumped = false
						@player.yvelocity = 0
						@player.y = tile.y - @player.height
					end
				end
				if a_is_below_b(@player, tile)
					@player.below = true
					if a_hits_bottom_of_b(@player, tile)
						@player.yvelocity = -@player.yvelocity / 8
					end
				end
			end
			@platformtilemap.each do |tile|
				if @player.yvelocity >= 0
					if a_is_above_b(@player, tile)
						if a_hits_top_of_b(@player, tile)
							if @player.below == false
								@player.bottcoll = true
								@player.jumped = false
								@player.yvelocity = 0
								@player.y = tile.y - @player.height
							end
						else
							@player.bottcoll = false
						end
					end
				end

			end
			@faketilesmap.each do |tile|
				if tile.transparency > 0
					tile.update
				end
				if a_is_inside_of_b(@player, tile)
					if tile.vanish == false
						tile.vanish = true
					end
				end
			end
			
			$xcamera = (@player.x + 5) - 98
			$ycamera = (@player.y + 7) - 80
			
			if @player.bottcoll == false
				@player.gravity
				if @player.jumped == false
					@player.jumped = true
					@player.sprite = 18
				end
			end
			
			if @player_aim_dummy.loop == 0
				@player_aim_dummy.x = @player.x + (@player.width / 2)
				@player_aim_dummy.y = @player.y + (@player.height / 2)
				@player_aim_dummy.x += @player.aimxv
				@player_aim_dummy.y += @player.aimyv
				@player_aim_dummy.loop += 1
			elsif @player_aim_dummy.loop >= 1 and @player_aim_dummy.loop <= 2
				@player_aim_dummy.x += @player.aimxv
				@player_aim_dummy.y += @player.aimyv
				@player_aim_dummy.loop += 1
			elsif @player_aim_dummy.loop = 3
				@player_aim_dummy.x += @player.aimxv
				@player_aim_dummy.y += @player.aimyv
				@player_aim_dummy.loop = 0
			end
			
			if @player.aimdir == "right"
				if button_down?(Gosu::KbUp)                 
					if @player.aimxv > 0
						if @player.aimyv <= 0
							@player.aimxv -= 0.5
							@player.aimyv -= 0.5
						elsif @player.aimyv > 0
							@player.aimxv += 0.5
							@player.aimyv -= 0.5
						end
					end
					if @player.aimxv <= 0 and @player.aimyv == @player.maxaim
						@player.aimxv = 0.5
						@player.aimyv = @player.maxaim - 0.5
					end
				end
				if button_down?(Gosu::KbDown)
					if @player.aimxv > 0
						if @player.aimyv < 0
							@player.aimxv += 0.5
							@player.aimyv += 0.5
						elsif @player.aimyv >= 0
							@player.aimxv -= 0.5
							@player.aimyv += 0.5
						end
					end
					if @player.aimxv <= 0 and @player.aimyv == @player.maxaim * -1
						@player.aimxv = 0.5
						@player.aimyv = (@player.maxaim * -1) + 0.5
					end
				end
			end
			if @player.aimdir == "left"
				if button_down?(Gosu::KbUp)                 
					if @player.aimxv < 0
						if @player.aimyv <= 0
							@player.aimxv += 0.5
							@player.aimyv -= 0.5
						elsif @player.aimyv > 0
							@player.aimxv -= 0.5
							@player.aimyv -= 0.5
						end
					end
					if @player.aimxv >= 0 and @player.aimyv == @player.maxaim
						@player.aimxv = -0.5
						@player.aimyv = @player.maxaim - 0.5
					end
				end
				if button_down?(Gosu::KbDown)
					if @player.aimxv < 0
						if @player.aimyv < 0
							@player.aimxv -= 0.5
							@player.aimyv += 0.5
						elsif @player.aimyv >= 0
							@player.aimxv += 0.5
							@player.aimyv += 0.5
						end
					end
					if @player.aimxv >= 0 and @player.aimyv == @player.maxaim * -1
						@player.aimxv = -0.5
						@player.aimyv = (@player.maxaim * -1) + 0.5
					end
				end
			end
			
			@crosshairarray.each do |crosshair|
				if crosshair.id == @player_aim_dummy.loop and @player.aimdir != "none"
					crosshair.x = @player_aim_dummy.x
					crosshair.y = @player_aim_dummy.y
				end
			end
			
		end
	end
	
	def draw
		@bg.draw(0, 0, 0)
		@player.draw
		@portrait.draw
		@solidtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@platformtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@airtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@decortilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@faketilesmap.each do |tile|
			tile.draw
		end
		@hpdarray.each do |hpd|
			hpd.draw
		end
		@crosshairarray.each do |crosshair|
			crosshair.draw
		end
		if $debugmode == true
			@debug.draw("#{@player.rightcoll}", 0, 0, 7)
			@debug.draw("#{@player.leftcoll}", 0, 8, 7)
			@debug.draw("#{@player.bottcoll}", 0, 16, 7)
			@debug.draw("#{@player.y}", 0, 24, 7)
			@debug.draw("#{@player.yvelocity}", 0, 32, 7)
		end
	end
	
	def a_is_right_of_b(a, b)
		a.x > b.x and a.y + a.height > b.y and a.y < b.y + b.height and a.x < b.x + b.width * 2
	end
	def a_hits_right_of_b(a, b)
		a.x <= b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height and not a.x < b.x
	end
	def a_is_left_of_b(a, b)
		a.x + a.width < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height and a.x + a.width > b.x - b.width
	end
	def a_hits_left_of_b(a, b)
		a.x + a.width >= b.x and a.y + a.height > b.y and a.y < b.y + b.height and not a.x > b.x + b.width
	end
	def a_is_below_b(a, b)
		a.y > b.y and a.x + a.width > b.x and a.x < b.x + b.width and a.y < b.y + b.height * 2
	end
	def a_hits_bottom_of_b(a, b)
		a.y <= b.y + b.height and a.x + a.width > b.x and a.x < b.x + b.width and not a.y < b.y
	end
	def a_is_above_b(a, b)
		a.y + a.height < b.y + b.height and a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y - b.height
	end
	def a_hits_top_of_b(a, b)
		a.y + a.height >= b.y and a.x + a.width > b.x and a.x < b.x + b.width and not a.y > b.y + b.height
	end
	def a_is_inside_of_b(a, b)
		a.x + a.width >= b.x and a.x <= b.x + b.width and a.y + a.height >= b.y and a.y <= b.y + b.height
	end
	
	def button_down(id)
		if id == Gosu::KbSpace
			if @player.moving == false and @player.jumped == false
				@player.aimdir = @player.facing
				if @player.facing == "right"
					@player.aimxv = @player.maxaim
				elsif @player.facing == "left"
					@player.aimxv = @player.maxaim * -1
				end
			end
		end
		if id == Gosu::KbLeft
			if @player.aimdir == "right"
				@player.aimdir = "left"
				@player.facing = "left"
				@player.aimxv = @player.aimxv * -1
			end
		end
		if id == Gosu::KbRight
			if @player.aimdir == "left"
				@player.aimdir = "right"
				@player.facing = "right"
				@player.aimxv = @player.aimxv * -1
			end
		end
	end
	def button_up(id)
		if id == Gosu::KbSpace
			if @player.aimdir != "none"
				@player.aimdir = "none"
				@player.aimxv = 0
				@player.aimyv = 0
				@crosshairarray.each do |crosshair|
					crosshair.x = -100
					crosshair.y = -100
				end
			end
		end
		if id == Gosu::KbEscape
			self.close
		end
		if id == Gosu::KbR
			@player.forcemove(4, 8, false)
			$playerhealth = 5
			@hpdarray.each do |hpd|
				hpd.reset
			end			
		end
		if id == Gosu::KbE
			@player.forcemove(33, 22, false)
		end
		if id == Gosu::KbF
			if @fullscreen == true
				@fullscreen = false
				self.fullscreen = false
			elsif @fullscreen == false
				@fullscreen = true
				self.fullscreen = true
			end
		end
		if id == Gosu::KbT
			if $playerhealth >= 1
				$playerhealth -= 1
			end
		end
	end
end

class Tile
	attr_accessor :id, :x, :y, :width, :height, :id, :rid, :lid, :tid, :bid, :nid
	def initialize(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write)
		@x = x * 16
		@y = y * 16
		@width = 16
		@height = 16
		@id = id
		@rid = rid
		@lid = lid
		@tid = tid
		@bid = bid
		@nid = nid
		@alwaysdraw = alwaysdraw
		@offset_fixer = 0
		@tileimages = $tilesimage
		@color = Gosu::Color.argb(0xff_ffffff)
		@stretchlimit = 6
		@write = write
		@debug = Gosu::Font.new(6)
	end
	
	def draw(playerx, playery)
		if @alwaysdraw == false
			if @id > 0
				@tileimages[@id].draw(@x - $xcamera, @y - $ycamera, 5)
			end
			if playerx > @x + @width and @rid > 0
				@tileimages[@rid].draw_as_quad(@x + @width - $xcamera, @y - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera + @offset_fixer, @color, 3)
			end
			if playerx < @x and @lid > 0
				@tileimages[@lid].draw_as_quad(@x - $xcamera, @y - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - @offset_fixer, @color, @x - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if playery + 7 < @y + @height and @tid > 0
				@tileimages[@tid].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - @offset_fixer, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x - $xcamera, @y - $ycamera, @color, @x + @width - $xcamera, @y - $ycamera, @color, 3 )
			end
			if playery - 14 > @y and @bid > 0
				@tileimages[@bid].draw_as_quad(@x - $xcamera, @y + @height - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera + @offset_fixer, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @nid > 0
				@tileimages[@nid].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 2)
			end
		elsif @alwaysdraw == true
			if @id > 0
				@tileimages[@id].draw(@x - $xcamera, @y - $ycamera, 5)
			end
			if @rid > 0
				@tileimages[@rid].draw_as_quad(@x + @width - $xcamera, @y - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera + @offset_fixer, @color, 3)
			end
			if @lid > 0
				@tileimages[@lid].draw_as_quad(@x - $xcamera, @y - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - @offset_fixer, @color, @x - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @tid > 0
				@tileimages[@tid].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - @offset_fixer, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x - $xcamera, @y - $ycamera, @color, @x + @width - $xcamera, @y - $ycamera, @color, 3 )
			end
			if @bid > 0
				@tileimages[@bid].draw_as_quad(@x - $xcamera, @y + @height - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera + @offset_fixer, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @nid > 0
				@tileimages[@nid].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 2)
			end
		end
		if $debugmode == true
			@debug.draw("#{@write}", @x - $xcamera, @y - $ycamera, 7)
		end
	end
end

class Decortile
	attr_accessor :id, :x, :y, :width, :height
	def initialize(x, y, id, animlength, stretchlimit, layer)
		@x = x * 16
		@y = y * 16
		@width = 16
		@height = 16
		@id = id
		@sprite = 0
		@animlength = animlength - 1
		@spriteresetmax = 10
		@spritereset = @spriteresetmax
		@tileimages = $tilesimage
		@color = Gosu::Color.argb(0xff_ffffff)
		@stretchlimit = stretchlimit
		@write = "decor"
		@debug = Gosu::Font.new(6)
		@layer = layer
	end
	
	def draw(playerx, playery)
		@tileimages[(@id + @sprite)].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @layer)
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

	end
end

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
			@image = Gosu::Image.new('fwgreen1.png')
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

class Player
	attr_accessor :x, :y, :width, :height, :facing, :jumped, :moving, :leftcoll, :rightcoll, :bottcoll, :topcoll, :yvelocity, :sprite, :below, :aimdir, :aimxv, :aimyv, :maxaim
	def initialize(x, y)
		@x = x * 16
		@y = y * 16
		@prex = x
		@prey = y
		@width = 10
		@height = 14
		@speed = 2
		@jumpvelocity = -4.0
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
		@below = false
		@aimdir = "none"
		@aimxv = 0
		@aimyv = 0
		@maxaim = 20
	end
	
	def movement(button)
		if @aimdir == "none"
			if button == "right"
				if @rightcoll == false
					@prex = @x
					@x += @speed
					@moving = true
					@facing = "right"
					if @jumped == false
						if @sprite < 6 or @sprite > 11
							@sprite = 6
						end
					end
				end
			elsif button == "left"
				if @leftcoll == false
					@x -= @speed
					@moving = true
					@facing = "left"
					if @jumped == false
						if @sprite < 6 or @sprite > 11
							@sprite = 6
						end
					end
				end
			end
		end
	end
	
	def jump
		if @aimdir == "none"
			if @jumped == false
				@jumped = true
				@yvelocity = @jumpvelocity
				@y += @yvelocity
				@sprite = 12
			end
		end
	end
	
	def not_moving
		@moving = false
		if @sprite < 2 or @sprite > 5
			@sprite = 2
		end
	end
	
	def gravity
		@yvelocity += $gravity
		@y += @yvelocity
	end
	
	def forcemove(x, y, keepvelocity)
		if keepvelocity == true
		elsif keepvelocity == false
			@yvelocity = 0
		end
		@x = x * 16
		@y = y * 16
	end
	
	def draw
		if facing == "right"
			if @jumped == false
				if @moving == false
					if @sprite >= 2 and @sprite <= 4
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 5
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 2
						end
					end
				elsif @moving == true
					if @sprite >= 6 and @sprite <= 10
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 11
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 6
						end
					end
				end
			elsif @jumped == true
				if @yvelocity < 0
					if @sprite >= 12 and @sprite <= 13
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 14
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 12
						end
					end
				elsif @yvelocity >= 0
					if @sprite >= 12 and @sprite <= 14
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 15
						end
					elsif @sprite >= 15 and @sprite <= 17
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite >= 18 and @sprite <= 19
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 20
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 18
						end
					end
				end
			end
			
			@spritesheet[@sprite].draw(@x - $xcamera - 3, @y - $ycamera - 3, 4)
			
		elsif facing == "left"
			if @jumped == false
				if @moving == false
					if @sprite >= 2 and @sprite <= 4
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 5
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 2
						end
					end
				elsif @moving == true
					if @sprite >= 6 and @sprite <= 10
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 11
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 6
						end
					end
				end
			elsif @jumped == true
				if @yvelocity < 0
					if @sprite >= 12 and @sprite <= 13
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 14
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 12
						end
					end
				elsif @yvelocity >= 0
					if @sprite >= 12 and @sprite <= 14
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 15
						end
					elsif @sprite >= 15 and @sprite <= 17
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite >= 18 and @sprite <= 19
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite += 1
						end
					elsif @sprite == 20
						if @spritereset == @spriteresetmax
							@spritereset = 0
							@sprite = 18
						end
					end
				end
			end
			
			@spritesheet[@sprite].draw(@x - $xcamera + 16 - 3, @y - $ycamera - 3, 4, -1.0, 1.0)
			
		end
		
		if @spritereset <= @spriteresetmax - 1
			@spritereset += 1
		end
	end
end

class Portrait
	def initialize (x, y)
		@x = x
		@y = y
		@image = Gosu::Image.new('portrait.png')
	end
	
	def draw
		@image.draw(@x, @y, 7)
	end
end

class Hpd
	attr_accessor :swiff, :size, :transparency
	def initialize (x, y, seq)
		@x = x
		@y = y
		@seq = seq
		@images = Gosu::Image.load_tiles('hpd.png', 9, 9)
		@maxdelay = 120 - (@seq * 6)
		@delay = @maxdelay
		@wik = 0
		@transparency = 255
		@size = 1.0
		@color = Gosu::Color.argb(0xff_ffffff)
		@swiff = 0
	end
	
	def draw
		if $playerhealth > @seq
			@images[@wik].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 7, @size, @size, @color)
		end
		@delay -= 1
		if @delay <= 0 and @delay >= -2
			@wik = 1
		elsif @delay <= -3 and @delay >= -5
			@wik = 2
		elsif @delay <= -6 and @delay >= -8
			@wik = 3
		elsif @delay <= -9 and @delay >= -11
			@wik = 4
		elsif @delay <= -12 and @delay >= -14
			@wik = 5
		elsif @delay <= -15
			@wik = 0
			@delay = @maxdelay + (@seq * 6)
		end
		if $playerhealth <= @seq
			@images[0].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 7, @size, @size, @color)
			if @swiff == 0
				if @transparency > 0
					@transparency -= 25
					@size += 0.25
					@color.alpha = @transparency
				end
				if @transparency <= 0
					@swiff = 1
				end
			end
		end
	end
	
	def reset
		@swiff = 0
		@size = 1
		@transparency = 255
		@color.alpha = 255
	end
end

class Crosshair
	attr_accessor :x, :y, :id
	def initialize (id)
		@x = -100
		@y = -100
		@id = id
		if @id == 1
			@image = Gosu::Image.new("crosshair1.png")
		elsif @id == 2
			@image = Gosu::Image.new("crosshair2.png")
		elsif @id == 3
			@image = Gosu::Image.new("crosshair3.png")
		end
	end
	
	def draw
		@image.draw(@x - $xcamera - (@id / 2), @y - $ycamera - (@id / 2), 6)
	end
	
	def move(x, y)
		@x = x
		@y = y
	end
end

class PlayerAimDummy
	attr_accessor :x, :y, :loop
	def initialize
		@x = 0
		@y = 0
		@loop = 0
	end
end

window = GameWindow.new
window.show