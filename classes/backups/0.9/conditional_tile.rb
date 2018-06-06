class ConditionalTile
	attr_accessor :id, :x, :y, :width, :height, :id, :rid, :lid, :tid, :bid, :nid, :canhit_r, :canhit_l, :canhit_t, :canhit_b, :condition, :reverse
	def initialize(x, y, id, rid, lid, tid, bid, nid, animlength, condition, write, reverse, image)
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
		@condition = condition
		@offset_fixer = 0
		@tileimages = image
		@color = 0x80_ffffff
		@stretchlimit = 6
		@write = write
		@debug = Gosu::Font.new(6)
		@canhit_r = 0
		@canhit_l = 0
		@canhit_t = 0
		@canhit_b = 0
		@sprite = 0
		@animlength = animlength - 1
		@spriteresetmax = 10
		@spritereset = 0
		@reverse = reverse
	end
	
	def draw(playerx, playery)
		if @animlength > 1
			if @spritereset < @spriteresetmax
				@spritereset += 1
			elsif @spritereset >= @spriteresetmax
				@spritereset = 0
				if @sprite < @animlength
					@sprite += 1
				elsif @sprite >= @animlength
					@sprite = 0
				end
			end
		end
		if $conditions[@condition] >= 1 and @reverse == false
			subdraw(playerx, playery)
		elsif $conditions[@condition] <= 0 and @reverse == true
			subdraw(playerx, playery)
		end
		if $debugmode == true
			@debug.draw("#{@write}", @x - $xcamera, @y - $ycamera, 7)
		end
	end
	
	def subdraw(playerx, playery)
			if @id > 0
				@tileimages[@id + @sprite].draw(@x - $xcamera, @y - $ycamera, 5, 1, 1, @color)
			end
			if @rid > 0
				@tileimages[@rid + @sprite].draw_as_quad(@x + @width - $xcamera, @y - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera + @offset_fixer, @color, 3)
			end
			if @lid > 0
				@tileimages[@lid + @sprite].draw_as_quad(@x - $xcamera, @y - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - @offset_fixer, @color, @x - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @tid > 0
				@tileimages[@tid + @sprite].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - @offset_fixer, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, @x - $xcamera, @y - $ycamera, @color, @x + @width - $xcamera, @y - $ycamera, @color, 3 )
			end
			if @bid > 0
				@tileimages[@bid + @sprite].draw_as_quad(@x - $xcamera, @y + @height - $ycamera, @color, @x + @width - $xcamera, @y + @height - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera + @offset_fixer, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 3)
			end
			if @nid > 0
				@tileimages[@nid + @sprite].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, ((((@x + @width) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera, ((((@y + @height) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera, @color, 2)
			end
	end
end