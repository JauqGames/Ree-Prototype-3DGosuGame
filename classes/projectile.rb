class Projectile
	attr_accessor :x, :y, :width, :height, :hits, :id, :xvelocity, :yvelocity, :prehit, :aimdeg, :active
	def initialize(x, y, xv, yv, id, aimdeg, map)
		@x = x
		@y = y
		@width = 2
		@height = 2
		@drawwidth = 8
		@drawheight = 8
		@hits = 0
		@image = map
		@id = id
		if @id == 0
			@srmin = 14
			@srmax = 17
		end
		@sprite = @srmin
		@spriteresetmax = 1
		@spritereset = 0
		@xvelocity = xv
		@yvelocity = yv
		@prehit = "none"
		@stretchlimit = 14
		@color = 0xff_ffffff
		@aimdeg = aimdeg
		@autoadjustlayer = true
		@p = 1000
		@aalayerx = 0
		@aalayery = 0
		@active = false
	end
	
	def gravity
		if @active
			@x += @xvelocity
			@y += @yvelocity
		end
	end
	
	def draw(playerx, playery)
		if @active
			if @autoadjustlayer == true
				@aalayerx = ((@x / 16).round - (playerx / 16).round).abs
				@aalayery = ((@y / 16).round - (playery / 16).round).abs
				@p = 1000
			else
				@aalayerx = 0
				@aalayery = 0
				@p = 0
			end
			@image[@sprite].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - (@drawwidth / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - (@drawheight / 2), @color, 25 + @p - @aalayerx - @aalayery)
			@spritereset += 1
			if @spritereset > @spriteresetmax
				@spritereset = 0
				@sprite += 1
				if @sprite >= @srmax
					@sprite = @srmin
				end
			end
		end
	end
end