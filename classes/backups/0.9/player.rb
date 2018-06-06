class Player
	attr_accessor :x, :y, :width, :height, :facing, :jumped, :moving, :leftcoll, :rightcoll, :bottcoll, :topcoll, :yvelocity, :sprite, :below, :aimdir, :aimdeg, :aimcharge, :sbwidth, :sb, :spriteresetmax, :spritereset, :hurt, :hurt_count
	def initialize(x, y, window, spritesheets)
		@x = x * 16
		@y = y * 16
		@prex = x
		@prey = y
		@width = 10
		@height = 14
		@speed = 2
		@jumpvelocity = -4.0
		@yvelocity = 0
		@tpsprites = spritesheets[0]
		@clsprites = spritesheets[1]
		@stsprites = spritesheets[2]
		@tcsprites = spritesheets[3]
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
		@aimdeg = 90
		@aimcharge = 0
		@hurt = 0
		@hurt_count = 0
		@cloak_color = $colorswitch
		@string_color = $colorswitch2
		@cloak_color2 = $colorswitch3
		@skin_color = 0xff_ffffff
		
		@stonebar =spritesheets[4]
		@slingshot =spritesheets[5]
		@sbwidth = 0.0
		@sb = 0
	end
	
	def movement(button)
		if @hurt == 0 or @hurt == 1
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
	end
	
	def jump
		if @hurt == 0 or @hurt == 1
			if @aimdir == "none"
				if @jumped == false
					@jumped = true
					@yvelocity = @jumpvelocity
					@y += @yvelocity
					@sprite = 12
				end
			end
		end
	end
	
	def hurt_player(damage = 0, direction = "none")
		if @hurt == 0
			@hurt = 3
			@hurt_count = 60
			if direction == "right"
				@facing = "left"
			elsif direction == "left"
				@facing = "right"
			end
			@y -= 3
			@yvelocity = -3
			@sprite = 22
			$playerhealth -= damage
			@hurt = 2
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
	
	def drawbar
		if @aimcharge > 0 and @aimcharge < 30
			@sbwidth = ((@aimcharge / 30.0) * 10.0)
		elsif @aimcharge >= 30
			if @sb == 0
				@sb = 1
			elsif @sb == 1
				@sb = 0
			end
		end
	end
	
	def draw
		if @hurt == 0
			@cloak_color = $colorswitch
			@skin_color = 0xff_ffffff
			@string_color = $colorswitch2
			@cloak_color2 = $colorswitch3
		else
			if @hurt_count > 0
				if @hurt_count % 2 == 0
					@hurt_count -= 1
					@cloak_color = $colorswitch
					@skin_color = 0xff_ffffff
					@string_color = $colorswitch2
					@cloak_color2 = $colorswitch3
				else
					@hurt_count -= 1
					@cloak_color = 0x00_000000
					@skin_color = 0x00_000000
					@string_color = 0x00_000000
					@cloak_color2 = 0x00_000000
				end
			else
				@hurt = 0
			end
		end
		if @aimcharge > 0 and @aimcharge < 30
			@stonebar[@sb].draw(@x - $xcamera, @y + 12 - $ycamera, 7, @sbwidth, 1)
		elsif @aimcharge >= 30
			@stonebar[@sb].draw(@x - $xcamera, @y + 12 - $ycamera, 7, 10, 1)
		end
		if facing == "right"
			if @hurt == 0 or @hurt == 1
				if @aimdir == "none"
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
				else
					@sprite = 21
				end
			else
				if @sprite >= 22 and @sprite <= 23
					if @spritereset == @spriteresetmax
						@spritereset = 0
						@sprite += 1
					end
				elsif @sprite == 24
					if @spritereset == @spriteresetmax
						@spritereset = 0
						@sprite = 22
					end
				else
					@sprite = 22
				end				
			end
			
			@tpsprites[@sprite].draw(@x - $xcamera - 3, @y - $ycamera - 3, 4, 1, 1, @skin_color)
			@clsprites[@sprite].draw(@x - $xcamera - 3, @y - $ycamera - 3, 4, 1, 1, @cloak_color)
			@tcsprites[@sprite].draw(@x - $xcamera - 3, @y - $ycamera - 3, 4, 1, 1, @cloak_color2)
			@stsprites[@sprite].draw(@x - $xcamera - 3, @y - $ycamera - 3, 4, 1, 1, @string_color)
			
			if @aimcharge > 0 and @aimcharge < 10
				@slingshot[0].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, 1, 0xff_ffffff)
			elsif @aimcharge >= 10 and @aimcharge < 20
				@slingshot[1].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, 1, 0xff_ffffff)
			elsif @aimcharge >= 20 and @aimcharge < 30
				@slingshot[2].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, 1, 0xff_ffffff)
			elsif @aimcharge >= 30
				@slingshot[3].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, 1, 0xff_ffffff)
			end
			
		elsif facing == "left"
			if @hurt == 0 or @hurt == 1
				if @aimdir == "none"
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
				else
					@sprite = 21
				end
			else
				if @sprite >= 22 and @sprite <= 23
					if @spritereset == @spriteresetmax
						@spritereset = 0
						@sprite += 1
					end
				elsif @sprite == 24
					if @spritereset == @spriteresetmax
						@spritereset = 0
						@sprite = 22
					end
				else
					@sprite = 22
				end				
			end
			
			@tpsprites[@sprite].draw(@x - $xcamera + 16 - 3, @y - $ycamera - 3, 4, -1.0, 1.0, @skin_color)
			@clsprites[@sprite].draw(@x - $xcamera + 16 - 3, @y - $ycamera - 3, 4, -1, 1, @cloak_color)
			@tcsprites[@sprite].draw(@x - $xcamera + 16 - 3, @y - $ycamera - 3, 4, -1, 1, @cloak_color2)
			@stsprites[@sprite].draw(@x - $xcamera + 16 - 3, @y - $ycamera - 3, 4, -1, 1, @string_color)
			
			if @aimcharge > 0 and @aimcharge < 10
				@slingshot[0].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, -1, 0xff_ffffff)
			elsif @aimcharge >= 10 and @aimcharge < 20
				@slingshot[1].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, -1, 0xff_ffffff)
			elsif @aimcharge >= 20 and @aimcharge < 30
				@slingshot[2].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, -1, 0xff_ffffff)
			elsif @aimcharge >= 30
				@slingshot[3].draw_rot(@x - $xcamera + (@width / 2), @y - $ycamera + (@height / 2), 4, @aimdeg - 90, 0.5, 0.5, 1, -1, 0xff_ffffff)
			end
			
		end
		
		if @spritereset <= @spriteresetmax - 1
			@spritereset += 1
		end
	end
end