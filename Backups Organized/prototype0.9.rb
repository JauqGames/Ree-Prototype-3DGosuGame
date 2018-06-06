	require 'gosu'
	classarray = ["breakable_tile", "button", "conditional_tile", "crosshair", "decortile", "enemy", "faketiles", "hazard_tile", "hpd", "particle", "player", "portrait", "stone", "tile", "visual_gem"]
	
	classarray.count.times do |z|
		require_relative "cls/#{classarray[z]}"
	end
	
	#Layer Data
		#8 = Load Screen
		#7 = Debug Numbers
		#6 = Fake Tiles
		#5 = Tiles
		#4 = Player
		#3 = 3D Tiles
		#2 = Rear Tiles
		#1 = ***Unused
		#0 = Far BG
		
	#Notes
		#@image = Gosu::Image.load_tiles('tiles.png', @width, @height)
	
class GameWindow < Gosu::Window

	def initialize()
		@screensizeadjust = 0
		super(196 + @screensizeadjust, 160 + @screensizeadjust)
		self.caption = ("prototype0.9")
		@fullscreen = true
		self.fullscreen = @fullscreen
		Gosu::enable_undocumented_retrofication
		
		$xcamera = 0
		$ycamera = 0
		@load = 1.0
		@currentlevel = 1.1
		$gravity = 0.20
		$debugmode = false
		$playermaxhealth = 5
		$playerhealth = $playermaxhealth
		
		@playerstartx = 0
		@playerstarty = 0
		
		$conditions = [0, 0, 0, 0, 0]
		$gems = [1, 0, 0, 0]
		
		$colorswitch = 0xff_ffffff
		$colorswitch2 = 0xff_ffffff
		$colorswitch3 = 0xff_ffffff
		@colorswitch_number = 0
		@colorswitch_direction = 0
		
		$tilesimage = Gosu::Image.load_tiles('img\green_tiles.png', 16, 16, :tileable => true)
		@bg = Gosu::Image.new('img\greenbg.png')
		@loadingbg = Gosu::Image.new('img\blackbg.png')
		@loadinganim = Gosu::Image.load_tiles('img\loading.png', 64, 16)
		@la = 0
		@lacountmax = 4
		@lacount = @lacountmax
		@showload = false
		@solid_format_count = 0
		@air_format_count = 0
		@decor_format_count = 0
		
		@solidtilemap = []
		@conditionaltilemap = []
		@platformtilemap = []
		@conditionalplatformtilemap = []
		@airtilemap = []
		@decortilemap = []
		@hazardtilemap = []
		@faketilesmap = []
		@breakabletilemap = []
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
		@hpdsprites = []
		@hpdsprites.push(Gosu::Image.load_tiles('img\hpdcl.png', 9, 9))
		@hpdsprites.push(Gosu::Image.load_tiles('img\hpdbg.png', 9, 9))
		@hpdsprites.push(Gosu::Image.load_tiles('img\hpdtct.png', 9, 9))
		@hpdsprites.push(Gosu::Image.load_tiles('img\hpdtcb.png', 9, 9))
		5.times do |count|
			if count == 0
				@hpdarray.push(Hpd.new(21, 12, count, @hpdsprites))
			elsif count == 1
				@hpdarray.push(Hpd.new(27, 6, count, @hpdsprites))
			elsif count == 2
				@hpdarray.push(Hpd.new(33, 12, count, @hpdsprites))
			elsif count == 3
				@hpdarray.push(Hpd.new(39, 6, count, @hpdsprites))
			elsif count == 4
				@hpdarray.push(Hpd.new(45, 12, count, @hpdsprites))
			end
		end
		@crosshair = Crosshair.new
		@stonearray = []
		@buttonarray = []
		@dustcloudarray = []
		@bluesparkarray = []
		@goldcoinarray = []
		@enemyarray = []
		@visualgemarray = []
	end
	
	def placesolidtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, tiles = $tilesimage)
		@solidtilemap.push(Tile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, tiles))
	end
	def placeplatformtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, tiles = $tilesimage)
		@platformtilemap.push(Tile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, tiles))
	end
	def placeairtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, tiles = $tilesimage)
		@airtilemap.push(Tile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, tiles))
	end
	def placedecortile(x, y, id, animlength, stretchlimit, layer, tiles = $tilesimage)
		@decortilemap.push(Decortile.new(x, y, id, animlength, stretchlimit, layer, tiles))
	end
	def placefaketiles(id, x, y, width, height)
		@faketilesmap.push(Faketiles.new(id, x, y, width, height))
	end
	def placebreakabletile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, health, tiles = $tilesimage)
		@breakabletilemap.push(BreakableTile.new(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, health, tiles))
	end
	def placehazardtiles(x, y, id, animlength, layer, tiles = $tilesimage)
		@hazardtilemap.push(HazardTile.new(x, y, id, animlength, layer, tiles))
	end
	def placeconditionalplatformtile(x, y, id, rid, lid, tid, bid, nid, animlength, condition, write, reverse, tiles = $tilesimage)
		@conditionalplatformtilemap.push(ConditionalTile.new(x, y, id, rid, lid, tid, bid, nid, animlength, condition, write, reverse, tiles))
	end
	def placeconditionaltile(x, y, id, rid, lid, tid, bid, nid, animlength, condition, write, reverse, tiles = $tilesimage)
		@conditionaltilemap.push(ConditionalTile.new(x, y, id, rid, lid, tid, bid, nid, animlength, condition, write, reverse, tiles))
	end
	def button(x, y, condition)
		@buttonarray.push(Button.new(x, y, condition))
	end
	def particle(id, zid, partmap = nil)
		partmap = Gosu::Image.load_tiles('img\particlemap.png', 8, 8)
		if id == 0
			@dustcloudarray.push(Particle.new(id, zid, partmap))
		elsif id == 1
			@bluesparkarray.push(Particle.new(id, zid, partmap))
		elsif id == 2
			@goldcoinarray.push(Particle.new(id, zid, partmap))
		end
	end
	def enemy(x, y, id, spritemap = nil)
		spritemap = Gosu::Image.load_tiles('img\enemyspritemap.png', 16, 16)
		@enemyarray.push(Enemy.new(x, y, id, spritemap))
	end
	def player(x, y, window = self, spritesheets = [])
		spritesheets.push(Gosu::Image.load_tiles('img\pltp.png', 16, 16))
		spritesheets.push(Gosu::Image.load_tiles('img\plcl.png', 16, 16))
		spritesheets.push(Gosu::Image.load_tiles('img\plst.png', 16, 16))
		spritesheets.push(Gosu::Image.load_tiles('img\pltc.png', 16, 16))
		spritesheets.push(Gosu::Image.load_tiles('img\stonebar.png', 1, 2))
		spritesheets.push(Gosu::Image.load_tiles('img\slingshot.png', 16, 16))
		@player = Player.new(x, y, window, spritesheets)
	end
	
	def generate_tiles(x, y, width, height, id)
		x -= 7
		y -= 7
		width += 14
		height += 14
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
	def build_rectangle(x, y, width, height, condition = 0, reverse = false, id = 40) 		#destructive if not conditional
		@genx = 0
		@geny = 0
		if condition == 0
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
		elsif condition >= 1
			if width == 1
				height.times do |z|
					placeconditionaltile(x, y + z, id, id, id, 0, 0, 0, 4, condition, "solid", reverse)
				end
			end
		end
	end
	def build_background(x, y, width, height)												#destructive
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
	def place_platform(x, y, width, id, condition = 0, reverse = false)						#additive
		if condition == 0
			placeplatformtile(x, y, id, 0, 0, 15, 0, 0, true, "plat")
			placeplatformtile(x + width - 1, y, id, 0, 0, 17, 0, 0, true, "plat")
			(width - 2).times do |z|
				placeplatformtile((x + 1 + z), y, id, 0, 0, 16, 0, 0, true, "plat")
				z += 1
			end
		elsif condition > 0
				placeconditionalplatformtile(x, y, id + 4, 0, id + 4, id, 0, id + 4, 4, condition, "plat", reverse)
				placeconditionalplatformtile(x + width - 1, y, id + 4, id + 4, 0, id, 0, id + 4, 4, condition, "plat", reverse)
				(width - 2).times do |z|
					placeconditionalplatformtile((x + 1 + z), y, id + 4, 0, 0, id, 0, id + 4, 4, condition, "plat", reverse)
					z += 1
				end	
		end
	end
	def format_tiles(tile, tile_type)
		if tile_type == "solid"
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
				tile.canhit_l = 1
				tile.canhit_t = 1
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 0
				tile.id = 12
				tile.canhit_r = 1
				tile.canhit_t = 1
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 0 and @tile_to_bottom == 1
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 0
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 1
				tile.id = 11
				tile.canhit_l = 1
				tile.canhit_b = 1
			elsif @tile_to_top == 0 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 9
				tile.canhit_r = 1
				tile.canhit_b = 1
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 0
				tile.id = 13
				tile.canhit_t = 1
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 0 and @tile_to_bottom == 1
				tile.id = 14
				tile.canhit_l = 1
			elsif @tile_to_top == 1 and @tile_to_left == 0 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 12
				tile.canhit_r = 1
			elsif @tile_to_top == 0 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 10
				tile.canhit_b = 1
			elsif @tile_to_top == 1 and @tile_to_left == 1 and @tile_to_right == 1 and @tile_to_bottom == 1
				tile.id = 7
			end
		elsif tile_type == "air"
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
	def format_decor(tile)
			@solidtilemap.each do |subtile|
				if tile.x - 16 == subtile.x and tile.y == subtile.y
					tile.sleft = true
				end
				if tile.x + 16 == subtile.x and tile.y == subtile.y
					tile.sright = true
				end
				if tile.y - 16 == subtile.y and tile.x == subtile.x
					tile.sabove = true
				end
				if tile.y + 16 == subtile.y and tile.x == subtile.x
					tile.sbelow = true
				end				
			end
			@platformtilemap.each do |subtile|
				if tile.x - 16 == subtile.x and tile.y == subtile.y
					tile.sleft = true
				end
				if tile.x + 16 == subtile.x and tile.y == subtile.y
					tile.sright = true
				end
				if tile.y - 16 == subtile.y and tile.x == subtile.x
					tile.sabove = true
				end
				if tile.y + 16 == subtile.y and tile.x == subtile.x
					tile.sbelow = true
				end				
			end
			@conditionalplatformtilemap.each do |subtile|
				if tile.x - 16 == subtile.x and tile.y == subtile.y
					tile.sleft = true
				end
				if tile.x + 16 == subtile.x and tile.y == subtile.y
					tile.sright = true
				end
				if tile.y - 16 == subtile.y and tile.x == subtile.x
					tile.sabove = true
				end
				if tile.y + 16 == subtile.y and tile.x == subtile.x
					tile.sbelow = true
				end				
			end				
	end
	def replace_tile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type) 					#destructive
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
		@hazardtilemap.each do |tile|
			if tile.x == (x * 16) and tile.y == (y * 16)
				@hazardtilemap.delete tile
			end
		end
		if type == "solid"
			placesolidtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type, $tilesimage)
		elsif type == "air"
			placeairtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type, $tilesimage)
		elsif type == "platform"
			placeplatformtile(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, type, $tilesimage)
		end
	end
	
	def update
		if @load == 1.0
		
			player(@playerstartx, @playerstarty)	
			
			particle(0, 0)
			particle(0, 1)
			particle(1, 0)
			particle(1, 1)
			particle(1, 2)
			particle(1, 3)
			particle(1, 4)
			particle(2, 0)
			particle(2, 1)

			@showload = true
			@load = @currentlevel
			
		elsif @load == 1.1
		
			generate_tiles(0, 0, 60, 35, 7)

			build_background(1, 2, 5, 4)
			build_background(3, 6, 3, 2)
			place_platform(3, 6, 3, 18, 0)
			build_background(6, 2, 10, 3)
			build_background(16, 1, 9, 3)
			build_background(18, 4, 7, 14)
			place_platform(18, 4, 2, 18, 0)
			build_background(1, 14, 17, 4)
			build_background(11, 18, 6, 3)
			place_platform(12, 17, 4, 40, 1)
			build_background(1, 18, 6, 10)
			place_platform(5, 18, 2, 18, 0)
			build_background(7, 24, 31, 4)
			build_background(13, 28, 4, 3)
			build_background(21, 28, 12, 3)
			place_platform(23, 28, 3, 18, 0)
			place_platform(28, 28, 3, 18, 0)
			build_background(30, 20, 8, 5)
			place_platform(30, 23, 4, 18, 0)
			build_background(30, 13, 3, 7)
			build_background(33, 13, 11, 4)
			build_background(34, 4, 6, 9)
			build_rectangle(36, 11, 2, 2)
			build_background(40, 17, 4, 13)
			place_platform(36, 26, 2, 18, 0)
			place_platform(36, 24, 2, 18, 0)
			place_platform(30, 21, 2, 18, 0)
			place_platform(30, 19, 2, 18, 0)
			place_platform(31, 17, 2, 18, 0)
			place_platform(34, 15, 2, 18, 0)
			place_platform(34, 13, 2, 18, 0)
			place_platform(34, 11, 2, 18, 0)
			place_platform(40, 25, 4, 18, 0)
			build_background(44, 22, 6, 3)
			build_background(49, 3, 10, 8)
			build_background(50, 11, 8, 14)
			build_background(28, 7, 4, 3)
			build_background(32, 9, 2, 1)
			
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
			placedecortile(22, 17, 34, 1, 17, 4)
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
				elsif z >= 4 and z <= 9
					placedecortile(3 + (4 * (z - 4)), 15, 21, 3, 7, 3)
				elsif z >= 10 and z <= 17
					placedecortile(3 + (4 * (z - 10)), 26, 21, 3, 7, 3)
				elsif z >= 18 and z <= 20
					placedecortile(32 + (4 * (z - 18)), 15, 21, 3, 7, 3)
				elsif z >= 21 and z <= 24
					placedecortile(42 + (4 * (z - 21)), 23, 21, 3, 7, 3)
				end
			end
			
			6.times do |z|
				placehazardtiles(11 + z, 20, 36, 1, 3)
			end
			4.times do |z|
				placehazardtiles(13 + z, 30, 36, 1, 3)
			end
			12.times do |z|
				placehazardtiles(21 + z, 30, 36, 1, 3)
			end
			
			button(13.5, 14.5, 1)
			
			@load = 1.11
			
		elsif @load == 1.11
			
			15.times do |z|
				if @solid_format_count + 1 <= @solidtilemap.count
					format_tiles(@solidtilemap[@solid_format_count], "solid")
					@solid_format_count += 1
				end
				if @air_format_count + 1 <= @airtilemap.count
					format_tiles(@airtilemap[@air_format_count], "air")
					@air_format_count += 1
				end
				if @decor_format_count + 1 <= @decortilemap.count
					format_decor(@decortilemap[@decor_format_count])
					@decor_format_count += 1
				end
			end
		
			if @solid_format_count + 1 > @solidtilemap.count and @decor_format_count + 1 > @decortilemap.count and @air_format_count + 1 > @airtilemap.count
				@load = 1.12
			end
			
		elsif @load == 1.12
		
			25.times do |z|
				if z >= 0 and z <= 3
					replace_tile(3 + (4 * z), 3, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 4 and z <= 9
					replace_tile(3 + (4 * (z - 4)), 15, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 10 and z <= 17
					replace_tile(3 + (4 * (z - 10)), 26, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 18 and z <= 20
					replace_tile(32 + (4 * (z - 18)), 15, 0, 0, 0, 0, 0, 24, false, "air")
				elsif z >= 21 and z <= 24
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
			
			@load = 1.13
			
		elsif @load == 1.13
		
			placefaketiles("g1", 27, 6, 7, 5)
			
			placebreakabletile(33, 9, 0, 37, 0, 0, 0, 0, false, "break", 3, $tilesimage)
			
			@playerstartx = 3
			@playerstarty = 6
			player(@playerstartx, @playerstarty)

			enemy(9, 3, 0)
			#enemy(21, 15, 1)
			
			@load = 2
			@showload = false	
			
		elsif @load == 1.2	
		
			generate_tiles(0, 0, 97, 52, 7)
			
			build_background(47, 0, 3, 43)
			build_background(38, 43, 14, 9)
			build_background(52, 43, 38, 5)
			3.times do |z|
				build_background(58 + (z * 4), 36, 2, 16)
			end
			build_background(71, 0, 6, 52)
			build_background(85, 31, 10, 16)
			build_background(93, 0, 4, 45)
			build_background(83, 13, 2, 24)
			build_background(85, 13, 8, 4)
			build_background(45, 31, 52, 5)
			build_background(60, 38, 2, 2)
			build_background(43, 31, 2, 6)
			build_background(0, 31, 43, 7)
			build_background(2, 38, 39, 1)
			build_background(4, 39, 35, 1)
			build_background(6, 40, 31, 1)
			build_background(8, 41, 27, 1)
			build_background(27, 42, 4, 10)
			build_background(5, 20, 8, 11)
			build_background(0, 15, 28, 5)
			build_background(26, 20, 2, 11)
			build_background(35, 20, 2, 11)
			build_background(30, 0, 2, 20)
			build_background(32, 15, 39, 5)
			build_background(7, 0, 11, 13)
			build_background(18, 7, 53, 6)
			build_background(68, 0, 3, 20)
			build_background(66, 13, 2, 1)
			build_background(77, 7, 6, 2)
			build_background(28, 30, 11, 1)
			
			build_background(20, 44, 5, 3)
			build_background(25, 44, 2, 1)
			
			build_background(52, 38, 4, 3)
			build_background(56, 40, 2, 1)
			
			build_background(30, 25, 3, 3)
			build_background(28, 27, 2, 1)
			
			build_rectangle(66, 15, 2, 1)
			
			place_platform(38, 48, 14, 18)
			place_platform(58, 48, 2, 18)
			place_platform(62, 48, 2, 18)
			4.times do |z|
				place_platform(85 + (z * 2), 37 + (z * 2), 4, 18)	
			end
			place_platform(93, 45, 2, 18)
			place_platform(93, 17, 4, 18)
			8.times do |z|
				place_platform(95, 19 + (z * 2), 2, 18)
			end
			place_platform(62, 36, 2, 18)
			place_platform(66, 36, 2, 18)
			3.times do |z|
				place_platform(28, 42 + (2 * z), 2, 18)
			end
			place_platform(21, 38, 3, 18)
			place_platform(21, 40, 3, 18)
			place_platform(5, 36, 16, 18)
			place_platform(5, 26, 2, 18)
			place_platform(5, 34, 2, 18)
			place_platform(11, 22, 2, 18)
			place_platform(11, 30, 2, 18)
			4.times do |z|
				place_platform(7, 20 + (4 * z), 4, 18)
			end
			place_platform(26, 33, 9, 18)
			7.times do |z|
				place_platform(35, 20 + (2 * z), 2, 18)
			end
			place_platform(68, 14, 3, 18)
			place_platform(69, 16, 2, 18)
			place_platform(69, 18, 2, 18)
			
			place_platform(72, 47, 4, 40, 1)
			place_platform(72, 35, 4, 40, 1, true)
			build_rectangle(46, 31, 1, 5, 2)
			build_rectangle(50, 31, 1, 5, 2)
			build_rectangle(46, 15, 1, 5, 3)
			build_rectangle(50, 15, 1, 5, 3)
			build_rectangle(46, 7, 1, 6, 4)
			build_rectangle(50, 7, 1, 6, 4)
			
			31.times do |z|
				if z >= 0 and z <= 13
					placedecortile(39 + (4 * z), 45, 21, 3, 7, 3)
				elsif z >= 14 and z <= 24
					placedecortile(52 + (4 * (z - 14)), 33, 21, 3, 7, 3)
				elsif z >= 25 and z <= 27
					placedecortile(86 + (4 * (z - 25)), 42, 21, 3, 7, 3)
				elsif z >= 28 and z <= 30
					placedecortile(86 + (4 * (z - 28)), 38, 21, 3, 7, 3)
				end
			end
			
			48.times do |z|
				placedecortile(48, 0 + z, 51, 4, 7, 3)
			end
			4.times do |z|
				placedecortile(48, 48 + z, 51, 4, 7, 2)
			end
			
			button(73.5, 43, 1)
			button(73.5, 31, 1)
			button(52, 32, 2)
			button(44, 16, 3)
			button(52, 8, 4)
			
			14.times do |z|
				placehazardtiles(38 + z, 51, 36, 1, 3)
			end
			3.times do |z|
				placehazardtiles(58 + (z * 4), 51, 36, 1, 3)
				placehazardtiles(59 + (z * 4), 51, 36, 1, 3)					
			end
			6.times do |z|
				placehazardtiles(71 + z, 51, 36, 1, 3)
			end
			4.times do |z|
				placehazardtiles(27 + z, 51, 36, 1, 3)
			end
			
			#TEST
			#@visualgemarray.push(VisualGem.new(48, 48, 0, Gosu::Image.load_tiles('img\smallgemsmap.png', 20, 20)))
			
			@load = 1.21
			
		elsif @load == 1.21
			
			15.times do |z|
				if @solid_format_count + 1 <= @solidtilemap.count
					format_tiles(@solidtilemap[@solid_format_count], "solid")
					@solid_format_count += 1
				end
				if @air_format_count + 1 <= @airtilemap.count
					format_tiles(@airtilemap[@air_format_count], "air")
					@air_format_count += 1
				end
				if @decor_format_count + 1 <= @decortilemap.count
					format_decor(@decortilemap[@decor_format_count])
					@decor_format_count += 1
				end
			end
		
			if @solid_format_count + 1 > @solidtilemap.count and @decor_format_count + 1 > @decortilemap.count and @air_format_count + 1 > @airtilemap.count
				@load = 1.22
			end
			
		elsif @load == 1.22
		
			14.times do |z|
				if z >= 0 or z <= 13
					replace_tile(39 + (4 * z), 45, 0, 0, 0, 0, 0, 24, false, "air")
				end
			end		
			
			@load = 1.23
			
		elsif @load == 1.23
		
			placefaketiles("g2", 19, 43, 8, 5)
			placebreakabletile(26, 44, 0, 37, 0, 0, 0, 0, false, "break", 3, $tilesimage)		
			placefaketiles("g3", 51, 37, 7, 5)
			placebreakabletile(57, 40, 0, 37, 0, 0, 0, 0, false, "break", 3, $tilesimage)		
			placefaketiles("g4", 28, 24, 6, 5)
			placebreakabletile(28, 27, 0, 0, 48, 0, 0, 0, false, "break", 3, $tilesimage)
			
			@playerstartx = 48
			@playerstarty = 0
			player(@playerstartx, @playerstarty)
			
			3.times do |z|
				$conditions[2 + z] = 1
			end
			
			@load = 2
			@showload = false

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
					@decortilemap.each do |tile|
						if a_is_inside_of_b(@player, tile) and tile.stretchlimit >= 17
							@goldcoinarray.each do |part|
								part.imdone = false
								part.sprite = part.srmin
								part.x = @player.x + (@player.width / 2)
								part.y = @player.y + @player.height - 2
								part.yvelocity = -3
								if part.zid == 0
									part.xvelocity = -1
								elsif part.zid == 1
									part.xvelocity = 1
								end
							end							
						end
					end
				end
			end
			@player.leftcoll = false
			@player.rightcoll = false
			@player.bottcoll = false
			@player.below = false
			@solidtilemap.each do |tile|
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
					solid_tile_collide_player(tile)
					@enemyarray.each do |enemy|
						solid_tile_collide_flyenemy(enemy, tile)
					end
				end
			end
			@conditionaltilemap.each do |tile|
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
					if $conditions[tile.condition] >= 1 and tile.reverse == false
						solid_tile_collide_player(tile)
						@enemyarray.each do |enemy|
							solid_tile_collide_flyenemy(enemy, tile)
						end
						if a_is_inside_of_b(@player, tile)
							if @player.x + (@player.width / 2) <= tile.x + (tile.width / 2)
								@player.x = tile.x - @player.width
							else
								@player.x = tile.x + tile.width
							end
						end
					elsif $conditions[tile.condition] <= 0 and tile.reverse == true
						solid_tile_collide_player(tile)
						@enemyarray.each do |enemy|
							solid_tile_collide_flyenemy(enemy, tile)
						end
						if a_is_inside_of_b(@player, tile)
							if @player.x + (@player.width / 2) <= tile.x + (tile.width / 2)
								@player.x = tile.x - @player.width
							else
								@player.x = tile.x + tile.width
							end
						end						
					end
				end
			end
			@platformtilemap.each do |tile|
				if @player.y + @player.height <= tile.y and @player.x + @player.width >= tile.x and @player.x <= tile.x + tile.width
					tile.platactive = true
				elsif @player.x + @player.width < tile.x or @player.x > tile.x + tile.width
					tile.platactive = false
				end
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160 and tile.platactive == true
					platform_tile_collide_player(tile)
				end
			end
			@conditionalplatformtilemap.each do |tile|
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
					if $conditions[tile.condition] >= 1 and tile.reverse == false
						platform_tile_collide_player(tile)
					elsif $conditions[tile.condition] <= 0 and tile.reverse == true
						platform_tile_collide_player(tile)
					end
				end
			end
			@hazardtilemap.each do |tile|
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
					if a_is_inside_of_b(@player, tile)
						$playerhealth -= 5
					end
				end
			end
			
			@decortilemap.each do |tile|
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
					tile.layering(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
				end
			end
			
			@stonearray.each do |stone|
				stone.gravity
				@solidtilemap.each do |tile|
					if a_is_inside_of_b(stone, tile)
						stone.hits += 1
					end
				end
				@conditionaltilemap.each do |tile|
					if a_is_inside_of_b(stone, tile)
						if $conditions[tile.condition] >= 1 and tile.reverse == false
							stone.hits += 1
						elsif $conditions[tile.condition] <= 0 and tile.reverse == true
							stone.hits += 1
						end
					end
				end
				@breakabletilemap.each do |tile|
					if a_is_inside_of_b(stone, tile)						
						tile.health += 1
						stone.hits += 1
					end
				end
				@platformtilemap.each do |tile|
					if a_is_above_b(stone, tile)					
						if a_hits_top_of_b(stone, tile)
							if stone.yvelocity > 0
								stone.hits += 1			
							end
						end
					end
				end
				@buttonarray.each do |button|
					if a_is_inside_of_b(stone, button)
						if $conditions[button.condition] == 0
							$conditions[button.condition] = 1
							stone.hits += 1
						elsif $conditions[button.condition] == 1
							$conditions[button.condition] = 0
							stone.hits += 1								
						end
					end
				end
				@enemyarray.each do |enemy|
					if a_is_inside_of_b(stone, enemy)
						enemy.xvelocity += (stone.xvelocity / 2)
						enemy.yvelocity += (stone.yvelocity / 2)
						stone.hits += 1
						enemy.hurt = 60
						enemy.health -= 1
					end
					if enemy.health <= 0
						@enemyarray.delete(enemy)
					end
				end
				if stone.hits >= 1
					@bluesparkarray.each do |part|
						part.imdone = false
						part.sprite = part.srmin
						part.x = stone.x + (stone.width / 2)
						part.y = stone.y + (stone.height / 2)
						part.xvelocity = Math.sin(((stone.aimdeg - 50 + (part.zid * 25)) * Math::PI) / 180) * -2.5
						part.yvelocity = Math.cos(((stone.aimdeg - 50 + (part.zid * 25)) * Math::PI) / 180) * 2.5					
					end
					@stonearray.delete(stone)
				end
			
			end
			@breakabletilemap.each do |tile|
				if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
					solid_tile_collide_player(tile)
				end
				if tile.health >= tile.deathhealth
					@breakabletilemap.delete(tile)
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
			
			if @player.aimdir == "right"
				if button_down?(Gosu::KbUp)                 
					if @player.aimdeg > 0
						@player.aimdeg -= 3
					end
				end
				if button_down?(Gosu::KbDown)
					if @player.aimdeg < 180
						@player.aimdeg += 3
					end
				end
			end
			if @player.aimdir == "left"
				if button_down?(Gosu::KbUp)                 
					if @player.aimdeg < 0
						@player.aimdeg += 3
					end
				end
				if button_down?(Gosu::KbDown)
					if @player.aimdeg > -180
						@player.aimdeg -= 3
					end
				end
			end
			
			if button_down?(Gosu::KbSpace)
				if @player.aimdir != "none"
					@player.aimcharge += 1
				end
			end
			
			if @player.aimdir != "none"
				@crosshair.x = @player.x + (@player.width / 2)
				@crosshair.y = @player.y + (@player.height / 2)
				@crosshair.rotate(@player.aimdeg)
			end
			
			if @player.hurt >= 2
				if @player.facing == "right"
					if @player.leftcoll == false
						@player.x -= 1.5
					end
				elsif @player.facing == "left"
					if @player.rightcoll == false
						@player.x += 1.5
					end
				end
			end
			
			if $playerhealth < 1
				@player.forcemove(4, 8, false)
				$playerhealth = $playermaxhealth
				@hpdarray.each do |hpd|
					hpd.reset
				end
				soft_reset
			end
			
			dostuffparticles
			
			@enemyarray.each do |enemy|
				enemy.leftcoll = false
				enemy.rightcoll = false
				enemy.bottcoll = false
				enemy.topcoll = false
				enemy.ai(@player)
				if enemy.atk >= 0
					if a_is_inside_of_b(@player, enemy)
						if enemy.x + enemy.width > @player.x + @player.width
							@player.hurt_player(1, "left")
						else
							@player.hurt_player(1, "right")
						end
					end
				end
			end
			if @colorswitch_number >= 0
				if $gems[@colorswitch_number] == 1
					if @colorswitch_number == 0
						$colorswitch = 0xff_af0000
						$colorswitch2 = 0xff_af6f00
						$colorswitch3 = 0xff_af0000
					elsif @colorswitch_number == 1
						$colorswitch = 0xff_ffffff
						$colorswitch2 = 0xff_ffffff
						$colorswitch3 = 0xff_ffffff
					elsif @colorswitch_number == 2
						$colorswitch = 0xff_00af00
						$colorswitch2 = 0xff_00af00
						$colorswitch3 = 0xff_00af00				
					elsif @colorswitch_number == 3
						$colorswitch = 0xff_0040af
						$colorswitch2 = 0xff_0040af
						$colorswitch3 = 0xff_0040af
					elsif @colorswitch_number == 4
						@colorswitch_number = 0
					end
				else
					@colorswitch_number += @colorswitch_direction
				end
			else
				@colorswitch_number = 3
			end		
		end
	end
	
	def draw												#draw
		if @showload == true
			@loadingbg.draw(0, 0, 8)
			@loadinganim[@la].draw(131, 143, 8)
			if @la < 5
				if @lacount == 1
					@lacount -= 1
					@la += 1
					@lacount = @lacountmax
				elsif @lacount > 1
					@lacount -= 1
				end
			elsif @la == 5
				if @lacount == 1
					@lacount -= 1
					@la = 0
					@lacount = @lacountmax
				elsif @lacount > 1
					@lacount -= 1
				end
			end
		end
		@bg.draw(0, 0, 0)
		@player.draw
		@player.drawbar
		@enemyarray.each do |enemy|
			enemy.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))			
		end
		@portrait.draw
		@airtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@solidtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@breakabletilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@platformtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@decortilemap.each do |tile|
			if tile.alwaysdraw == true
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			elsif tile.alwaysdraw == false and tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@conditionaltilemap.each do |tile|
			tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
		end
		@conditionalplatformtilemap.each do |tile|
			tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
		end
		@hazardtilemap.each do |tile|
			if tile.x + tile.width + 20 > $xcamera and tile.x - 20 < $xcamera + 196 and tile.y + tile.height + 20 > $ycamera and tile.y - 20 < $ycamera + 160
				tile.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@faketilesmap.each do |tile|
			tile.draw
		end
		@buttonarray.each do |button|
			button.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
		end
		@hpdarray.each do |hpd|
			hpd.draw
		end
		@crosshair.draw
		@stonearray.each do |stone|
			stone.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
		end
		drawparticles
		@visualgemarray.each do |gem|
			gem.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
		end

		if $debugmode == true
			@debug.draw("#{@player.rightcoll}", 0, 0, 7)
			@debug.draw("#{@player.leftcoll}", 0, 8, 7)
			@debug.draw("#{@player.bottcoll}", 0, 16, 7)
			@debug.draw("#{@player.y}", 0, 24, 7)
			@debug.draw("#{@player.yvelocity}", 0, 32, 7)
		end
		
	end
	
	def drawparticles
		@dustcloudarray.each do |part|
			if part.imdone == false
				part.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@bluesparkarray.each do |part|
			if part.imdone == false
				part.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
		@goldcoinarray.each do |part|
			if part.imdone == false
				part.draw(@player.x + (@player.width / 2), @player.y + (@player.height / 2))
			end
		end
	end
	
	def dostuffparticles
		@dustcloudarray.each do |part|
			if part.imdone == false
				part.do_stuff
			end
		end
		@bluesparkarray.each do |part|
			if part.imdone == false
				part.do_stuff
			end
		end
		@goldcoinarray.each do |part|
			if part.imdone == false
				part.do_stuff
			end
		end
	end
	
	def solid_tile_collide_player(tile)
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
				@player.y = tile.y - @player.height
				if @player.yvelocity >= 3
					@dustcloudarray.each do |part|
						part.imdone = false
						part.sprite = part.srmin
						part.x = @player.x + (@player.width / 2)
						part.y = @player.y + @player.height - 2
						if part.zid == 0
							part.xvelocity = -1.5
						elsif part.zid == 1
							part.xvelocity = 1.5
						end
					end
				end
				if @player.hurt == 2
					@player.hurt = 1
				end
				@player.yvelocity = 0
			end
		end
		if a_is_below_b(@player, tile)
			@player.below = true
			if a_hits_bottom_of_b(@player, tile)
				if @player.yvelocity < 0
					@player.y = tile.y + tile.height
					@player.yvelocity = -@player.yvelocity / 2
				end
			end
		end
		if a_is_inside_of_b(@player, tile)
			if @player.x + (@player.width / 2) <= tile.x + (tile.width / 2)
				@player.x = tile.x - @player.width
			else
				@player.x = tile.x + tile.width
			end
		end
		@goldcoinarray.each do |part|
			if a_is_right_of_b(part, tile)
				if a_hits_right_of_b(part, tile) and part.xvelocity < 0
					part.xvelocity = part.xvelocity * -1
				end
			end
			if a_is_left_of_b(part, tile)
				if a_hits_left_of_b(part, tile) and part.xvelocity > 0
					part.xvelocity = part.xvelocity * -1
				end
			end
			if a_is_above_b(part, tile)
				if a_hits_top_of_b(part, tile) and part.imdone == false
					part.imdone = true
				end
			end
		end
	end
	def platform_tile_collide_player(tile)
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
					if @player.hurt == 2
						@player.hurt = 1
					end
				end
			end
		end
	end
	def solid_tile_collide_flyenemy(enemy, tile)
		if a_is_above_b(enemy, tile) and not a_hits_top_of_b(enemy, tile)
			if enemy.id == 0 or enemy.id == 1 and enemy.health > 0
				enemy.yvelocity -= 0.15
				enemy.bottcoll = false
			end
		elsif a_is_above_b(enemy, tile) and a_hits_top_of_b(enemy, tile)
			if enemy.yvelocity != 0
				enemy.yvelocity = 0
			else
				enemy.yvelocity -= 0.15	
			end
			enemy.y = tile.y - enemy.height
			enemy.bottcoll = true
			if enemy.health <= 0
				@enemyarray.delete(enemy)
			end
		end
		if a_is_below_b(enemy, tile) and not a_hits_bottom_of_b(enemy, tile)
			if enemy.id == 0 or enemy.id == 1 and enemy.health > 0
				enemy.yvelocity += 0.15
				enemy.topcoll = false
			end
		elsif a_is_below_b(enemy, tile) and a_hits_bottom_of_b(enemy, tile)
			if enemy.yvelocity != 0
				enemy.yvelocity = 0
			else
				enemy.yvelocity += 0.15	
			end
			enemy.y = tile.y + tile.height
			enemy.topcoll = true
		end
		if a_is_right_of_b(enemy, tile) and not a_hits_right_of_b(enemy, tile)
			if enemy.id == 0 or enemy.id == 1 and enemy.health > 0
				enemy.xvelocity += 0.15
				enemy.leftcoll = false
			end
		elsif a_is_right_of_b(enemy, tile) and a_hits_right_of_b(enemy, tile)
			if enemy.xvelocity != 0
				enemy.xvelocity = 0
			else
				enemy.xvelocity += 0.15	
			end
			enemy.x = tile.x + tile.width
			enemy.leftcoll = true
		end
		if a_is_left_of_b(enemy, tile) and not a_hits_left_of_b(enemy, tile)
			if enemy.id == 0 or enemy.id == 1 and enemy.health > 0
				enemy.xvelocity -= 0.15
				enemy.rightcoll = false
			end
		elsif a_is_left_of_b(enemy, tile) and a_hits_left_of_b(enemy, tile)
			if enemy.xvelocity != 0
				enemy.xvelocity = 0
			else
				enemy.xvelocity -= 0.15	
			end
			enemy.x = tile.x - enemy.width
			enemy.rightcoll = true
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
		a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height
	end
	
	def soft_reset
		@showload = true
		@load = -15.0
		@enemyarray.clear
		@breakabletilemap.clear
		@faketilesmap.clear
		$conditions.each do |z|
			$conditions[z] = 0
		end
		@load = @currentlevel + 0.03
		@load = @load.round(2)
	end
	
	def reset_world
		@showload = true
		@load = -15.0
		@solidtilemap.clear
		@platformtilemap.clear
		@conditionalplatformtilemap.clear
		@airtilemap.clear
		@decortilemap.clear
		@hazardtilemap.clear
		@faketilesmap.clear
		@breakabletilemap.clear
		@stonearray.clear
		@buttonarray.clear
		@dustcloudarray.clear
		@bluesparkarray.clear
		@goldcoinarray.clear
		@enemyarray.clear
		@solid_format_count = 0
		@air_format_count = 0
		@decor_format_count = 0
		$conditions.each do |z|
			$conditions[z] = 0
		end
		@genx = 0
		@geny = 0
		@genz = 0
		@build_dizzy = 0
		@tile_to_right = 0
		@tile_to_left = 0
		@tile_to_top = 0
		@tile_to_bottom = 0
		@load = 1.0
	end
	
	def button_down(id)
		if id == Gosu::KbSpace
			if @player.moving == false and @player.jumped == false
				@player.aimdir = @player.facing
				if @player.facing == "right"
					if @player.aimdeg > 0
						@player.aimdeg = @player.aimdeg
					else
						@player.aimdeg = @player.aimdeg * -1
					end
				elsif @player.facing == "left"
					if @player.aimdeg < 0
						@player.aimdeg = @player.aimdeg
					else
						@player.aimdeg = @player.aimdeg * -1
					end
				end
			end
		end
		if id == Gosu::KbLeft
			if @player.aimdir == "right"
				@player.aimdir = "left"
				@player.facing = "left"
				@player.aimdeg = @player.aimdeg * -1
			end
		end
		if id == Gosu::KbRight
			if @player.aimdir == "left"
				@player.aimdir = "right"
				@player.facing = "right"
				@player.aimdeg = @player.aimdeg * -1
			end
		end
	end
	def button_up(id)
		if id == Gosu::KbSpace
			if @player.aimdir != "none"
				@player.aimdir = "none"
				if @player.aimcharge >= 30
					@player.aimcharge = 0
					@player.sbwidth = 0.0
					@player.sb = 0
					@stonearray.push(Stone.new(@player.x + (@player.width / 2), @player.y + (@player.height / 2), Math.sin((@player.aimdeg * Math::PI) / 180), Math.cos((@player.aimdeg * Math::PI) / 180), @player.aimdeg))
					@bluesparkarray.each do |part|
						if part.zid <= 2
							part.imdone = false
							part.sprite = part.srmin
							part.x = @player.x + (@player.width / 2)
							part.y = @player.y + (@player.height / 2)
							part.xvelocity = Math.sin(((@player.aimdeg - 25 + (part.zid * 25)) * Math::PI) / 180) * -2.5
							part.yvelocity = Math.cos(((@player.aimdeg - 25 + (part.zid * 25)) * Math::PI) / 180) * 2.5
						end						
					end
				else
					@player.aimcharge = 0
					@player.sbwidth = 0.0
					@player.sb = 0
				end
				@crosshair.x = -1000
				@crosshair.y = -1000
			end
		end
		if id == Gosu::KbEscape
			self.close
		end
		if id == Gosu::KbY
			@player.forcemove(4, 8, false)
			$playerhealth = $playermaxhealth
			@hpdarray.each do |hpd|
				hpd.reset
			end
			reset_world
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
				$playerhealth -= 2
			end
		end
		if id == Gosu::KbR
			@colorswitch_number += 1
			@colorswitch_direction = 1
		end
		if id == Gosu::KbQ
			@colorswitch_number -= 1
			@colorswitch_direction = -1
		end
	end
end

window = GameWindow.new
window.show