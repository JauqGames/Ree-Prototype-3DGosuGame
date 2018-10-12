class Enemy
	attr_accessor :id, :x, :y, :width, :height, :stretchlimit, :health, :xvelocity, :yvelocity, :bottcoll, :topcoll, :rightcoll, :leftcoll, :hurt, :atk
	def initialize(x, y, id, spritemap, window)
		@x = x * 16
		@y = y * 16
		@drawwidth = 16
		@drawheight = 16
		@id = id
		@tileimages = spritemap
		@window = window
		@facing = "left"
		if @id == 0
			@width = 8
			@height = 8
			@srmin = 0
			@srmax = 3
			@health = 2
			@personality = rand(30..40)
			@srdead = 8
			@atk = 1
			@spriteresetmax = 1
		elsif @id == 1
			@width = 8
			@height = 8
			@srmin = 4
			@srmax = 7
			@health = 2
			@facing = "right"
			@personality = rand(40..50)
			@srdead = 8
			@atk = 1
			@spriteresetmax = 1
		elsif @id == 2
			@width = 8
			@height = 8
			@srmin = 8
			@srmax = 10
			@health = 2
			@personality = rand(90..110)
			@srdead = 8
			@atk = 1
			@spriteresetmax = @personality
		end
		@sprite = @srmin
		@spritereset = @spriteresetmax
		@color = 0xff_ffffff
		@stretchlimit = 14
		@write = "decor"
		@debug = Gosu::Font.new(6)
		@xvelocity = 0
		@yvelocity = 0
		@active = 0
		@bottcoll = false
		@topcoll = false
		@rightcoll = false
		@leftcoll = false
		@hurt = 0
		@autoadjustlayer = true
		@p = 1000
		@aalayerx = 0
		@aalayery = 0
		@timer = 0
		@maxtimer = 0
	end
	
	def detectplayer(player, width, height)
		player.x + player.width > @x - width and player.x < @x + @width + width and player.y + player.height > @y - height and player.y < @y + @height + height	
	end
	
	def ai(player) #(player, solidtiles) player.x // playerx
		if @health == 0

		elsif @health > 0
			if @id == 0
				@maxtimer = 270
				if @xvelocity > 1.5
					@xvelocity = 1.5
				elsif @xvelocity < -1.5
					@xvelocity = -1.5
				end
				if @yvelocity > 1.0
					@yvelocity = 1.0
				elsif @yvelocity < -1.0
					@yvelocity = -1.0
				end
				@x += @xvelocity
				@y += @yvelocity
				if @active == 0
					@yvelocity = 0
					@xvelocity = 0
					@timer = 0
					if detectplayer(player, 110, 90)
						@active = 1
					end
				elsif @active == 1
					if not detectplayer(player, 110, 90)
						@active = 0
						@xvelocity = 0
						@yvelocity = 0
					end
					if @x > player.x + (player.width / 2)
						if @x > player.x + (player.width / 2) + @personality
							if @leftcoll == false
								@xvelocity -= 0.1
							end
							@facing = "left"
						elsif @x == player.x + (player.width / 2) + @personality
							if @xvelocity > 0
								if @leftcoll == false
									@xvelocity -= 0.1
								end
								@facing = "left"
							elsif @xvelocity < 0
								if @rightcoll == false
									@xvelocity += 0.1
								end
								@facing = "left"
							end
						elsif @x < player.x + (player.width / 2) + @personality
							if @rightcoll == false
								@xvelocity += 0.1
							end
							@facing = "left"
						end
					elsif @x < player.x + (player.width / 2)
						if @x < player.x + (player.width / 2) - @personality
							if @rightcoll == false
								@xvelocity += 0.1
							end
							@facing = "right"
						elsif @x == player.x + (player.width / 2) - @personality
							if @xvelocity > 0
								if @leftcoll == false
									@xvelocity -= 0.1
								end
								@facing = "right"
							elsif @xvelocity < 0
								if @rightcoll == false
									@xvelocity += 0.1
								end
								@facing = "right"
							end
						elsif @x > player.x + (player.width / 2) - @personality
							if @leftcoll == false
								@xvelocity -= 0.1
							end
							@facing = "right"
						end
					end
					if @y > player.y + player.height
						if @topcoll == false
							@yvelocity -= 0.1
							@timer += 1
						end
					elsif @y + @height < player.y
						if @bottcoll == false
							@yvelocity += 0.1
							@timer += 1
						end
					elsif @y <= player.y + player.height and @y + @height >= player.y
						if @yvelocity > 0.1 or @yvelocity < -0.1
							@yvelocity = @yvelocity / 1.08
							@timer += 2
						else
							@yvelocity = 0
							@timer += 2
						end
					end
					if @timer >= @maxtimer - (@maxtimer / 10).round and @timer < @maxtimer
						
					elsif @timer >= @maxtimer
						@timer = 0
						if @facing == "left"
							temp = -4
							@xvelocity += 3
						elsif @facing == "right"
							temp = 4
							@xvelocity -= 3
						end
						@window.use_proj(@x + (@width / 2), @y + (@height / 2), temp, 0, 0)
						temp = [0, 1]
						@id = temp.sample
						if @id == 1
							@srmin = 4
							@srmax = 7
							@sprite = 4
							@personality += 10
						end
					end
				end
			elsif @id == 1
				@maxtimer = 270
				if @xvelocity > 1.5
					@xvelocity = 1.5
				elsif @xvelocity < -1.5
					@xvelocity = -1.5
				end
				if @yvelocity > 1.0
					@yvelocity = 1.0
				elsif @yvelocity < -1.0
					@yvelocity = -1.0
				end
				@x += @xvelocity
				@y += @yvelocity
				if @active == 0
					@yvelocity = 0
					@xvelocity = 0
					@timer = 0
					if detectplayer(player, 110, 90)
						@active = 1
					end
				elsif @active == 1
					if not detectplayer(player, 110, 90)
						@active = 0
						@xvelocity = 0
						@yvelocity = 0
					end
					if @y > player.y + (player.height / 2)
						@yvelocity -= 0.1
					elsif @y < player.y + (player.height / 2)
						if @y < player.y + (player.height / 2) - @personality
							if @bottcoll == false
								@yvelocity += 0.1
							end
						elsif @y == player.y + (player.height / 2) - @personality
							if @yvelocity > 0
								if @topcoll == false
									@yvelocity -= 0.1
								end
							elsif @yvelocity < 0
								if @bottcoll == false
									@yvelocity += 0.1
								end
							end
						elsif @y > player.y + (player.height / 2) - @personality
							if @topcoll == false
								@yvelocity -= 0.1
							end
						end
					end
					if @x > player.x + player.width
						if @leftcoll == false
							@xvelocity -= 0.1
							@facing = "left"
							@timer += 1
						end
					elsif @x + @width < player.x
						if @rightcoll == false
							@xvelocity += 0.1
							@facing = "right"
							@timer += 1
						end
					elsif @x <= player.x + player.width and @x + @width >= player.x
						if @xvelocity > 0.1 or @xvelocity < -0.1
							@xvelocity = @xvelocity / 1.08
							@timer += 2
						else
							@xvelocity = 0
							@timer += 2
						end
					end
					if @timer >= @maxtimer - (@maxtimer / 10).round and @timer < @maxtimer
						
					elsif @timer >= @maxtimer
						@timer = 0
						@window.use_proj(@x + (@width / 2), @y + (@height / 2), 0, 3, 0)
						@yvelocity -= 3
						temp = [0, 1]
						@id = temp.sample
						if @id == 0
							@personality -= 10
							@srmin = 0
							@srmax = 3
							@sprite = 0
						end
					end
				end
			elsif @id == 2
				@maxtimer = 120
				if @active == 0
					@yvelocity = 0
					@xvelocity = 0
					@timer = 0
					if detectplayer(player, 110, 90)
						@active = 1
					end
				elsif @active == 1
					if not detectplayer(player, 110, 90)
						@active = 0
						@xvelocity = 0
						@yvelocity = 0
					end
					@x += @xvelocity
					@y += @yvelocity
					if @xvelocity < -0.1 or @xvelocity > 0.1
						@xvelocity /= 1.03
					else
						@xvelocity = 0
					end
					if @yvelocity < -0.1 or @yvelocity > 0.1
						@yvelocity /= 1.03
					else
						@yvelocity = 0
					end
					@timer += 1
					if @personality - @timer > 0
						@spriteresetmax = @personality - @timer
					else
						@spriteresetmax = 1
					end
					if @timer >= @maxtimer - (@maxtimer / 10).round and @timer < @maxtimer
					elsif @timer == @maxtimer
						angle = @window.find_angle(@x + (@width / 2), @y + (@height / 2), player.x, player.y)
						@yvelocity = Math.sin((angle * Math::PI) / 180) * 4
						@xvelocity = Math.cos((angle * Math::PI) / 180) * 4
					elsif @timer >= @maxtimer + 40
						@timer = 0
					end
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
		if @facing == "left"
			@tileimages[(@id + @sprite)].draw_as_quad((((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, 20 + @p - @aalayerx - @aalayery)
		elsif @facing == "right"
			@tileimages[(@id + @sprite)].draw_as_quad(((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), (((@y * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, ((((@x + @drawwidth) * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, (((@x * (@stretchlimit - 1)) + playerx) / @stretchlimit) - $xcamera - ((@drawwidth - @width) / 2), ((((@y + @drawheight) * (@stretchlimit - 1)) + playery) / @stretchlimit) - $ycamera - ((@drawheight - @height) / 2), @color, 20 + @p - @aalayerx - @aalayery)
		end
		if @health > 0
			if @spritereset < @spriteresetmax
				@spritereset += 1
			elsif @spritereset >= @spriteresetmax
				@spritereset = 0
				@sprite += 1
				if @sprite >= @srmax
					@sprite = @srmin
				end
			end
			if @hurt > 1
				if @color == 0xff_ffffff
					@color = 0x00_ffffff
				elsif @color == 0x00_ffffff
					@color = 0xff_ffffff
				end
				@hurt -= 1
			elsif @hurt == 1
				@color = 0xff_ffffff
				@hurt = 0
			end
		elsif @health <= 0
			@color = 0xff_ffffff
			@sprite = @srdead
		end
	end
end