package openfl.shaders.blendMode;

import openfl.display.BitmapData;
import openfl.display.GraphicsShader;
import openfl.utils.ByteArray;

/**
 * Blend Mode : alpha mask. Use greyscale texture to mask (white full opacity, black full transparency)
 * @author Loudo
 */
class AlphaMask extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		void main(void) {
			
			#pragma body
			
			vec4 mask = texture2D (foreground, openfl_TextureCoordv);
			float sum = (mask.r + mask.g + mask.b) / 3.0;
			
			
			gl_FragColor *= sum;			
			
		}
		"
	)

	public function new(foreground:BitmapData) 
	{
		super();
		data.foreground.input = foreground;
		
	}
	
}