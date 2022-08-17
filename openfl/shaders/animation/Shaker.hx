package openfl.shaders.animation;

import openfl.display.GraphicsShader;

/**
 * Shaker Animation
 * @link https://github.com/ktingvoar/PixiGlitch/blob/master/src/shaker.frag
 * @author adapted by Loudo for OpenFl
 */
class Shaker extends GraphicsShader 
{
	
	public var maxBlurX:Float;
	public var maxBlurY:Float;
	
	@:glFragmentSource(
		"#pragma header
		
		uniform vec2 blur;
		void main (void)
		{
		   vec4 col = texture2D(bitmap, openfl_TextureCoordv);
		   float pix_w = 1.0 / openfl_TextureSize.x;
		   float pix_h = 1.0 / openfl_TextureSize.y;
		   vec4 col_s[5], col_s2[5];
		   for (int i = 0;i < 5;i++){
			   col_s[i] = texture2D(bitmap, openfl_TextureCoordv + vec2(-pix_w * float(i) * blur.x, -pix_h * float(i) * blur.y));
			   col_s2[i] = texture2D(bitmap, openfl_TextureCoordv + vec2( pix_w * float(i) * blur.x, pix_h * float(i) * blur.y));
		   }
		   col_s[0] = (col_s[0] + col_s[1] + col_s[2] + col_s[3] + col_s[4])/5.0;
		   col_s2[0]= (col_s2[0] + col_s2[1] + col_s2[2] + col_s2[3] + col_s2[4])/5.0;
		   col = (col_s[0] + col_s2[0]) / 2.0;
		   gl_FragColor = col * openfl_Alphav;
		}
		
		"
	)
	
	
	/**
	 * 
	 * @param	blurX
	 * @param	blurY
	 */
	public function new(blurX:Float = 1., blurY:Float = 1.) 
	{
		maxBlurX = blurX;
		maxBlurY = blurY;
		super();
		data.blur.value = [0., 0.];
		
	}
	
	/**
	 * Animate by calling this method
	 */
	public function onUpdate(elapsed:Float):Void
	{
		data.blur.value[0] = Math.random() * maxBlurX;
		data.blur.value[1] = Math.random() * maxBlurY;
	}
	
}