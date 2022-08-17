package openfl.shaders.animation;

import openfl.display.GraphicsShader;

/**
 * Swell Animation
 * @link https://github.com/ktingvoar/PixiGlitch/blob/master/src/swell.frag
 * @author adapted by Loudo for OpenFl
 */
class Swell extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform float u_rand;
		uniform float u_time;
		
		void main (void)
		{
		   vec2 pos = openfl_TextureCoordv * vec2(openfl_TextureSize);
		   vec2 sampleFrom = (pos + vec2(sin(pos.y * 0.03 + u_time * 20.0) * (6.0 + 12.0 * u_rand), 0)) / vec2(openfl_TextureSize);
		   vec4 col_s = texture2D(bitmap, sampleFrom);
		   gl_FragColor = col_s * openfl_Alphav;
		}
		
		"
	)
	
	
	/**
	 * 
	 * @param	blurX
	 * @param	blurY
	 */
	public function new(u_rand:Float = 1.) 
	{
		super();
		data.u_rand.value = [u_rand];
		data.u_time.value = [0.];
		
	}
	
	/**
	 * Animate by calling this method
	 */
	public function onUpdate(elapsed:Float):Void
	{
		data.u_time.value[0] = elapsed;
	}
	
}