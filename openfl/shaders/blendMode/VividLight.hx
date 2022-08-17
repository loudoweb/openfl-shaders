package openfl.shaders.blendMode;

import openfl.display.BitmapData;
import openfl.display.GraphicsShader;

/**
 * Blend Mode : Increase or decrease contrast when blend color is lighter than 50% grey
 * @author Jamie Owen https://github.com/jamieowen/glsl-blend
 * @author adapted by Loudo
 */
class VividLight extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		float blendColorBurn(float base, float blend) {
			return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
		}
		
		float blendColorDodge(float base, float blend) {
			return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
		}
		
		float blendVividLight(float base, float blend) {
			return (blend<0.5)?blendColorBurn(base,(2.0*blend)):blendColorDodge(base,(2.0*(blend-0.5)));
		}

		vec3 blendVividLight(vec3 base, vec3 blend) {
			return vec3(blendVividLight(base.r,blend.r),blendVividLight(base.g,blend.g),blendVividLight(base.b,blend.b));
		}

		vec3 blendVividLight(vec3 base, vec3 blend, float opacity) {
			return (blendVividLight(base, blend) * opacity + base * (1.0 - opacity));
		}
		
		void main(void) {
			
			vec4 bgColor = texture2D(bitmap, openfl_TextureCoordv);
			vec4 fgColor = texture2D(foreground, openfl_TextureCoordv);
			vec3 blendedColor = blendVividLight(bgColor.rgb, fgColor.rgb, fgColor.a);
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