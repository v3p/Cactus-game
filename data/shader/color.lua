local color = [[
	extern number time;
	extern number strength;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		vec4 pixel = Texel(tex, tc);

		pixel.b = pixel.b + ( (sin(time * 2.0) * 0.5) * strength);
		pixel.g = pixel.g + ( (cos(time * 2.0) * 0.5) * strength);
		return pixel;
	}

	]]

return color