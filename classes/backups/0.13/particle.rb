class Particle
	attr_accessor :x, :y, :imdone, :zid, :id, :srmin, :splayback, :sprite, :xvelocity, :yvelocity, :width, :height
	def initialize(id, zid, partmap)
		@x = -1000
		@y = -1000
		@id = id
		@zid = zid
		@particle_sheet = partmap
		@width = 8
		@height = 8
		if @id == 0
			@srmin = 0
			@srmax = 5
			@splaybackmax = 2
		elsif @id == 1
			@srmin = 6
			@srmax = 9
			@splaybackmax = 2
		elsif @id == 2
			@srmin = 10
			@srmax = 13
			@splaybackmax = 2
			@width = 2
			@height = 2
		end
		@drawwidth = 8
		@drawheight = 8
		@sprite = @srmin
		@splayback = @splaybackmax
		@imdone = true
		@xvelocity = 0
		@yvelocity = 0
		@stretchlimit = 14
		@color = 0xff_ffffff
		@autoadjustlayer = true
		@p = 1000
		@aalayerx = 0
		@aalayery = 0
	end
	
	def do_stuff
		@x += @xvelocity
		@y += @yvelocity
		if @id == 0 or @id == 1
			if @splayback > 0
				@splayback -= 1
			elsif @splayback <= 0
				@splayback = @splaybackmax
				@sprite += 1
				if @sprite == @srmax
					@imdone = true
				end
			end
		elsif @id == 2
			@yvelocity += $gravity
			if @splayback > 0
				@splayback -= 1
			elsif @splayback <= 0
				@splayback = @splaybackmax
				if @sprite < @srmax
					@sprite += 1
				elsif @sprite == @srmax
					@sprite = @srmin
				end
			end
		end
	end
	
	def draw(playerx, playery)
		if @autoadjustlayer == true
			@aalayerx = ((@x / 16).round - (playerx / 16).round).abs
			@aalayery = ((@y / 16).round - (playery / 16).round).abs
			@p = 1000
		else
			@aalayerx = 0
			@aalayery = 0
			@p = 0
		end
		@particle_sheet[@sprite].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, 25 + @p - @aalayerx - @aalayery)
	end
end