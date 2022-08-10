package openfl.shaders.blendMode;

import openfl.display.BitmapData;
import openfl.display.GraphicsShader;

/**
 * Blend Mode
 * @author Jamie Owen https://github.com/jamieowen/glsl-blend
 * @author adapted by Loudo
 */
class ColorBurn extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		
		float blendColorBurn(float base, float blend) {
			return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
		}

		vec3 blendColorBurn(vec3 base, vec3 blend) {
			return vec3(blendColorBurn(base.r,blend.r),blendColorBurn(base.g,blend.g),blendColorBurn(base.b,blend.b));
		}

		vec3 blendColorBurn(vec3 base, vec3 blend, float opacity) {
			return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
		}
		
		void main(void) {
			
			vec4 bgColor = texture2D(bitmap, openfl_TextureCoordv);
			vec4 fgColor = texture2D(foreground, openfl_TextureCoordv);
			vec3 blendedColor = blendColorBurn(bgColor.rgb, fgColor.rgb, fgColor.a);
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