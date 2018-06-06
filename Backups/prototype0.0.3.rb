
	require 'gosu'
	
	#Layer Data
		#7 = Debug Numbers
		#5 = Tiles
		#4 = Player
		#3 = 3D Tiles
		#2 = Rear Tiles
		
	#Notes
		#@image = Gosu::Image.load_tiles('tiles.png', @width, @height)
		#@image.count = gives count of images
	
class GameWindow < Gosu::Window

	def initialize()
		super(196, 160)
		self.caption = ("Simplest Game")
		@fullscreen = false
		self.fullscreen = @fullscreen
		Gosu::enable_undocumented_retrofication
		
		$xcamera = 0
		$ycamera = 0
		@load = 1.0
		$gravity = 0.2
		$debugmode = false
		
		$tilesimage = Gosu::Image.load_tiles('green_tiles.png', 16, 16)
		
		@solidtilemap = []
		@platformtilemap = []
		@airtilemap = []
		@player = Player.new(4, 8)
		@debug = Gosu::Font.new(8)
		@genx = 0
		@geny = 0
		@genz = 0
		@build_dizzy = 0
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
	
	def generate_default_tiles(x, y, width, height, id) 							#non-destructive
		(width * height).times do
			placeairtile(@genx + x, @geny + y, id, 0, 0, 0, 0, 0, false, "air")
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
	def carve_rectangle(x, y, width, height, bg) 									#destructive
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
		placesolidtile(x, y, 13, 0, 0, 0, 0, 0, false, "solid")
		placesolidtile(x + width - 1, y, 13, 0, 0, 0, 0, 0, false, "solid")
		placesolidtile(x, y + height - 1, 13, 0, 0, 0, 0, 0, false, "solid")
		placesolidtile(x + width - 1, y + height - 1, 13, 0, 0, 0, 0, 0, false, "solid")
		(width - 2).times do |z|
			placesolidtile((x + 1 + z), y, 13, 0, 0, 0, 7, 0, false, "solid")
			placesolidtile((x + 1 + z), y + height - 1, 10, 0, 0, 4, 0, 0, false, "solid")
			z += 1
		end
		(height - 2).times do |z|
			placesolidtile(x, (y + 1 + z), 14, 8, 0, 0, 0, 0, false, "solid")
			placesolidtile(x + width - 1, (y + 1 + z), 12, 0, 6, 0, 0, 0, false, "solid")
			z += 1
		end
	end
	def place_platform(x, y, width, id, nid, nidrange) 									#destructive
		@genx = 0
		@geny = 0
		(width).times do
			@airtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (y * 16) 
					@airtilemap.delete tile
				end
			end
			@solidtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (y * 16)
					@solidtilemap.delete tile
				end
			end
			@platformtilemap.each do |tile|
				if tile.x == (@genx * 16) + (x * 16) and tile.y == (y * 16)
					@platformtilemap.delete tile
				end
			end
			@genx += 1
			if @genx >= width
				@genx = 0
			end
		end
		placeplatformtile(x, y, id, 0, 0, 15, 0, nid - nidrange, true, "plat")
		placeplatformtile(x + width - 1, y, id, 0, 0, 17, 0, nid + nidrange, true, "plat")
		(width - 2).times do |z|
			placeplatformtile((x + 1 + z), y, id, 0, 0, 16, 0, nid, true, "plat")
			z += 1
		end
	end
	def build_background(x, y, width, height, topside, leftside, rightside) 		#non-destructive
		if topside == true and leftside == true
			placeairtile(x, y, 0, 0, 0, 0, 0, 9, false, "air")
		elsif topside == true and leftside == false
			placeairtile(x, y, 0, 0, 0, 0, 0, 10, false, "air")
		elsif topside == false and leftside == true
			placeairtile(x, y, 0, 0, 0, 0, 0, 12, false, "air")
		elsif topside == false and leftside == false
			placeairtile(x, y, 0, 0, 0, 0, 0, 13, false, "air")
		end
		if topside == true and rightside == true
			placeairtile(x + width - 1, y, 0, 0, 0, 0, 0, 11, false, "air")
		elsif topside == true and rightside == false
			placeairtile(x + width - 1, y, 0, 0, 0, 0, 0, 10, false, "air")
		elsif topside == false and rightside == true
			placeairtile(x + width - 1, y, 0, 0, 0, 0, 0, 14, false, "air")
		elsif topside == false and rightside == false
			placeairtile(x + width - 1, y, 0, 0, 0, 0, 0, 13, false, "air")
		end
		(width - 2).times do |z|
			if topside == true
				placeairtile((x + 1 + z), y, 0, 0, 0, 0, 0, 10, false, "air")
			elsif topside == false
				placeairtile((x + 1 + z), y, 0, 0, 0, 0, 0, 13, false, "air")
			end
			z += 1
		end
		(height - 1).times do |z|
			if leftside == true
				placeairtile(x, (y + 1 + z), 0, 0, 0, 0, 0, 12, false, "air")
			elsif leftside == false
				placeairtile(x, (y + 1 + z), 0, 0, 0, 0, 0, 13, false, "air")
			end
			if rightside == true
				placeairtile(x + width - 1, (y + 1 + z), 0, 0, 0, 0, 0, 14, false, "air")
			elsif rightside == false
				placeairtile(x + width - 1, (y + 1 + z), 0, 0, 0, 0, 0, 13, false, "air")
			end
			z += 1
		end
		@genx = 0
		@geny = 0
		((width - 2) * (height - 1)).times do
			placeairtile(x + 1 + @genx, y + 1 + @geny, 0, 0, 0, 0, 0, 13, false, "air")
			@genx += 1
			if @genx >= width - 2
				@genx = 0
				@geny += 1
			end	
			if @geny >= height - 1 and @genx >= width - 2
				@genx = 0
				@geny = 0
			end
		end
	end
	def clear_rectangle(x, y, width, height) 										#destructive
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
	def fill(x, y, width, height, id, rid, lid, tid, bid, nid, alwaysdraw, type)	#destructive
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
		(width * height).times do
			if type == "solid"
				placesolidtile(x + @genx, y + @geny, id, rid, lid, tid, bid, nid, alwaysdraw, type)
			elsif type == "air"
				placeairtile(x + @genx, y + @geny, id, rid, lid, tid, bid, nid, alwaysdraw, type)
			elsif type == "platform"
				placeplatformtile(x + @genx, y + @geny, id, rid, lid, tid, bid, nid, alwaysdraw, type)
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
	end
	
	def update
		if @load == 1.0
		
			generate_default_tiles(-7, -7, 67, 38, 7)

			carve_rectangle(0, 1, 7, 6, true)
			carve_rectangle(2, 6, 5, 3, true)
			build_background(1, 2, 5, 4, true, true, false)
			replace_tile(2, 6, 11, 5, 0, 4, 0, 0, false, "solid")
			replace_tile(6, 6, 12, 0, 6, 0, 0, 0, false, "solid")
			clear_rectangle(3, 6, 3, 1)
			carve_rectangle(6, 1, 10, 5, true)
			clear_rectangle(6, 2, 1, 3)
			build_background(6, 2, 9, 3, true, false, false)
			replace_tile(6, 5, 9, 0, 3, 4, 0, 0, false, "solid")
			replace_tile(6, 1, 13, 0, 0, 0, 7, 0, false, "solid")
			build_background(3, 6, 3, 2, false, true, true)
			replace_tile(5, 5, 0, 0, 0, 0, 0, 14, false, "air")
			place_platform(3, 6, 3, 18, 13, 1)

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
					else
						@player.bottcoll = false
					end
				end
				if a_is_below_b(@player, tile)
					if a_hits_bottom_of_b(@player, tile)
						@player.yvelocity = @player.yvelocity / 8
					end
				end
			end
			@platformtilemap.each do |tile|
				if @player.yvelocity >= 0
					if a_is_above_b(@player, tile)
						if a_hits_top_of_b(@player, tile)
							@player.bottcoll = true
							@player.jumped = false
							@player.yvelocity = 0
							@player.y = tile.y - @player.height
						else
							@player.bottcoll = false
						end
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
			
		end
	end
	
	def draw
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
		@player.draw
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
	
	def button_up(id)
		if id == Gosu::KbEscape
			self.close
		end
		if id == Gosu::KbR
			@player.forcemove(4, 8, false)
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
	end
end

class Tile
	attr_reader :id, :x, :y, :width, :height
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
			if playery < @y + @height and @tid > 0
				@tileimages[@tid].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - @offset_fixer, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x - $xcamera, @y - $ycamera, @color, @x + @width - $xcamera, @y - $ycamera, @color, 3 )
			end
			if playery > @y and @bid > 0
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

class Player
	attr_accessor :x, :y, :width, :height, :facing, :jumped, :moving, :leftcoll, :rightcoll, :bottcoll, :topcoll, :yvelocity, :sprite
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
	end
	
	def movement(button)
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
	
	def jump
		if @jumped == false
			@jumped = true
			@yvelocity = @jumpvelocity
			@y += @yvelocity
			@sprite = 12
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

window = GameWindow.new
window.show
