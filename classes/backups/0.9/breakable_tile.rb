class BreakableTile
	attr_accessor :id, :x, :y, :width, :height, :id, :rid, :lid, :tid, :bid, :nid, :canhit_r, :canhit_l, :canhit_t, :canhit_b, :health, :deathhealth
	def initialize(x, y, id, rid, lid, tid, bid, nid, alwaysdraw, write, health, image) #37
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
		@tileimages = image
		@color = Gosu::Color.argb(0xff_ffffff)
		@stretchlimit = 6
		@write = write
		@debug = Gosu::Font.new(6)
		@canhit_r = 0
		@canhit_l = 0
		@canhit_t = 0
		@canhit_b = 0
		@deathhealth = health
		@health = 0
	end
	
	def draw(playerx, playery)
		if @alwaysdraw == false
			if @id > 0
				@tileimages[@id + @health].draw(@x - $xcamera, @y - $ycamera, 5)
			end
			if playerx > @x + @width and @rid > 0
				@tileimages[@rid + @health].draw_as_quad(@x + @width - $xcamera, @y - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera + @offset_fixer, @color, 3)
			end
			if playerx < @x and @lid > 0
				@tileimages[@lid + @health].draw_as_quad(@x - $xcamera, @y - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - @offset_fixer, @color, @x - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if playery + 7 < @y + @height and @tid > 0
				@tileimages[@tid + @health].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - @offset_fixer, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x - $xcamera, @y - $ycamera, @color, @x + @width - $xcamera, @y - $ycamera, @color, 3)
			end
			if playery - 14 > @y and @bid > 0
				@tileimages[@bid + @health].draw_as_quad(@x - $xcamera, @y + @height - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera + @offset_fixer, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @nid > 0
				@tileimages[@nid + @health].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 2)
			end
		elsif @alwaysdraw == true
			if @id > 0
				@tileimages[@id + @health].draw(@x - $xcamera, @y - $ycamera, 5)
			end
			if @rid > 0
				@tileimages[@rid + @health].draw_as_quad(@x + @width - $xcamera, @y - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera + @offset_fixer, @color, 3)
			end
			if @lid > 0
				@tileimages[@lid + @health].draw_as_quad(@x - $xcamera, @y - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - @offset_fixer, @color, @x - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @tid > 0
				@tileimages[@tid + @health].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - @offset_fixer, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x - $xcamera, @y - $ycamera, @color, @x + @width - $xcamera, @y - $ycamera, @color, 3 )
			end
			if @bid > 0
				@tileimages[@bid + @health].draw_as_quad(@x - $xcamera, @y + @height - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera + @offset_fixer, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @nid > 0
				@tileimages[@nid + @health].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 2)
			end
		end
		if $debugmode == true
			@debug.draw("#{@write}", @x - $xcamera, @y - $ycamera, 7)
		end
	end
end
