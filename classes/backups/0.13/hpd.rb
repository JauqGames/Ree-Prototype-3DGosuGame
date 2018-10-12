class Hpd
	attr_accessor :swiff, :size, :transparency
	def initialize (x, y, seq, sprites)
		@x = x
		@y = y
		@seq = seq
		@images = sprites[0]
		@imagesbg = sprites[1]
		if @y == 6
			@imagestc = sprites[2]
		elsif @y == 12
			@imagestc = sprites[3]
		end
		@maxdelay = 120 - (@seq * 6)
		@delay = @maxdelay
		@wik = 0
		@transparency = 255
		@size = 1.0
		@color = Gosu::Color.argb(0xff_ffffff)
		@color2 = Gosu::Color.argb($colorswitch)
		@color3 = Gosu::Color.argb($colorswitch3)
		@swiff = 0
		@p = 1000
	end
	
	def draw
		@color2 = Gosu::Color.argb($colorswitch)
		@color3 = Gosu::Color.argb($colorswitch3)
		if $playerhealth > @seq
			@images[@wik].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 35 + @p, @size, @size, @color2)
			@imagestc[@wik].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 35 + @p, @size, @size, @color3)
			@imagesbg[@wik].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 35 + @p, @size, @size, @color)
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
			if @swiff == 0
				if @transparency > 0
					@transparency -= 25
					@size += 0.25
					@color.alpha = @transparency
					@color2.alpha = @transparency
					@color3.alpha = @transparency
				end
				if @transparency <= 0
					@swiff = 1
				end
			end
			if @swiff == 1
				@color.alpha = @transparency
				@color2.alpha = @transparency
				@color3.alpha = @transparency
			end
			@imagesbg[0].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 35 + @p, @size, @size, @color)
			@images[0].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 35 + @p, @size, @size, @color2)
			@imagestc[0].draw(@x - (4.5 * (@size - 1)), @y - (4.5 * (@size - 1)), 35 + @p, @size, @size, @color3)
		end
	end
	
	def reset
		@swiff = 0
		@size = 1
		@transparency = 255
		@color.alpha = 255
		@color2.alpha = 255
		@color3.alpha = 255
	end
end