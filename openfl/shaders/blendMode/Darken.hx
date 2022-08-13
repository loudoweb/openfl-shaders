package openfl.shaders.blendMode;

import openfl.display.BitmapData;
import openfl.display.GraphicsShader;

/**
 * Blend Mode
 * @author Jamie Owen https://github.com/jamieowen/glsl-blend
 * @author adapted by Loudo
 */
class Darken extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		
		float blendDarken(float base, float blend) {
			return min(blend,base);
		}

		vec3 blendDarken(vec3 base, vec3 blend) {
			return vec3(blendDarken(base.r,blend.r),blendDarken(base.g,blend.g),blendDarken(base.b,blend.b));
		}

		vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
			return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
		}
		
		void main(void) {
			
			vec4 bgColor = texture2D(bitmap, openfl_TextureCoordv);
			vec4 fgColor = texture2D(foreground, openfl_TextureCoordv);
			vec3 blendedColor = blendDarken(bgColor.rgb, fgColor.rgb, fgColor.a);
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