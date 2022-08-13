package openfl.shaders.blendMode;

import openfl.display.BitmapData;
import openfl.display.GraphicsShader;

/**
 * Blend Mode
 * @author Jamie Owen https://github.com/jamieowen/glsl-blend
 * @author adapted by Loudo
 * //TODO add mask
 */
class Exclusion extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		
		vec3 blendExclusion(vec3 base, vec3 blend) {
			return base+blend-2.0*base*blend;
		}

		vec3 blendExclusion(vec3 base, vec3 blend, float opacity) {
			return (blendExclusion(base, blend) * opacity + base * (1.0 - opacity));
		}
		
		void main(void) {
			
			vec4 bgColor = texture2D(bitmap, openfl_TextureCoordv);
			vec4 fgColor = texture2D(foreground, openfl_TextureCoordv);
			vec3 blendedColor = blendExclusion(bgColor.rgb, fgColor.rgb, fgColor.a);
			gl_FragColor = vec4(blendedColor , bgColor.a);
			gl_FragColor = gl_FragColor * openfl_Alphav;
		}
		
		"
	)

	public function new(foreground:BitmapData) 
	{
		super();
		data.foreground.input = foreground;
		
	}
	
}