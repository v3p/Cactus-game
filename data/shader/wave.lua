local wave = [[
	extern number strength;
	extern vec2 screen;
	extern highp float time;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		tc.y = tc.y + sin(  (tc.x * 30.0) + (time * 10.0) ) * (screen.y * 0.0005) * strength;
		return Texel(tex, tc) * color;
	}

	]]

return wave