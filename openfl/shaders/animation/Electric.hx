package openfl.shaders.animation;

import openfl.display.GraphicsShader;

/**
 * Electric Animation
 * LICENSE: CC-BY-SA 3.0
 * @author Teeworlds Copyright (c) 2007-2014 Magnus Auvinen
 * @author Ninslash Copyright (c) 2016 Juho Syrjänen
 * @link https://github.com/Siile/Ninslash/blob/master/data/shaders/electric.frag
 * @author adapted by Loudo for OpenFl
 */
class Electric extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform float rnd;
		uniform float intensity;

		float rand(vec2 co)
		{
			float a = 12.9898;
			float b = 78.233;
			float c = 43758.5453;
			float dt= dot(co.xy ,vec2(a,b));
			float sn= mod(dt,3.14);
			return fract(sin(sn) * c);
		}


		vec4 Electrify(vec4 c)
		{
			float f = rand(vec2(int(gl_FragCoord.y/3.*rnd), int(gl_FragCoord.x/3.*rnd)))*rand(vec2(int(gl_FragCoord.y/3.*rnd), int(gl_FragCoord.x/3.*rnd)));
			float c1 = texture2D(bitmap, openfl_TextureCoordv).x + texture2D(bitmap, openfl_TextureCoordv).y + texture2D(bitmap, openfl_TextureCoordv).z;
			c1 *= 3.0;
			
			float col = (1.0 - min(c1, 0.5)) * f;
			vec4 color = vec4(-col*0.3, col*0.9, col, 0.0);
			c += color * intensity;
			
			return c;
		}

		void main (void)
		{
			vec4 c = texture2D(bitmap, openfl_TextureCoordv);

			if (intensity > 0.0)
				c = Electrify(c);
			
			gl_FragColor = c * openfl_Alphav;
		}
		
		"
	)
	
	

	/**
	 * 
	 * @param	intensity
	 * @param	random TODO set to time as it is the variable to animate
	 * @param	colorSwap
	 */
	public function new(intensity:Float = 1., random:Float = 0.) 
	{
		super();
		data.intensity.value = [intensity];
		data.rnd.value = [random];
		
	}
	
	/**
	 * Animate by calling this method
	 */
	public function onUpdate(elapsed:Float):Void
	{
		data.rnd.value[0] = elapsed;
	}
	
}