package openfl.shaders.blendMode;

import openfl.display.BitmapData;
import openfl.display.GraphicsShader;

/**
 * Blend Mode
 * @author Jamie Owen https://github.com/jamieowen/glsl-blend
 * @author adapted by Loudo
 */
class SoftLight extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		
		float blendSoftLight(float base, float blend) {
			return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
		}

		vec3 blendSoftLight(vec3 base, vec3 blend) {
			return vec3(blendSoftLight(base.r,blend.r),blendSoftLight(base.g,blend.g),blendSoftLight(base.b,blend.b));
		}

		vec3 blendSoftLight(vec3 base, vec3 blend, float opacity) {
			return (blendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
		}
		
		void main(void) {
			
			vec4 bgColor = texture2D(bitmap, openfl_TextureCoordv);
			vec4 fgColor = texture2D(foreground, openfl_TextureCoordv);
			vec3 blendedColor = blendSoftLight(bgColor.rgb, fgColor.rgb, fgColor.a);
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