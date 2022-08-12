package openfl.shaders;

import openfl.display.GraphicsShader;
import openfl.utils.ByteArray;

/**
 * port from Pixi : https://github.com/pixijs/filters/blob/main/filters/glow/src/glow.frag
 * @author adapted by Loudo
 */
class Glow extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform float distance;
		uniform float quality;
		
		uniform float outerStrength;
		uniform float innerStrength;

		uniform vec4 glowColor;

		uniform bool knockout;
		
		const vec4 filterClamp = vec4(0.,0., 20., 20.);

		const float PI = 3.14159265358979323846264;
		
		//__ANGLE_STEP_SIZE__ => (1 / quality / distance).toFixed(7)
		const float ANGLE_STEP_SIZE = min((1. / .1 / 10.), PI * 2.0);
		const float ANGLE_STEP_NUM = ceil(PI * 2. / ANGLE_STEP_SIZE);
		const float MAX_TOTAL_ALPHA = ANGLE_STEP_NUM * 10. * (10. + 1.0) / 2.0;


		void main(void) {
			vec2 px = vec2(1.0 / openfl_TextureSize.x, 1.0 / openfl_TextureSize.y);

			float totalAlpha = 0.0;
			
			vec2 direction;
			vec2 displaced;
			vec4 curColor;

			for (float angle = 0.0; angle < PI * 2.0; angle += ANGLE_STEP_SIZE) {
			   direction = vec2(cos(angle), sin(angle)) * px;

			   for (float curDistance = 0.0; curDistance < 100.0; curDistance++) {
					if(curDistance + 1. == distance) break;//early return hack
					displaced = clamp(openfl_TextureCoordv + direction * 
						   (curDistance + 1.0), filterClamp.xy, filterClamp.zw);

					curColor = texture2D(bitmap, displaced);

					totalAlpha += (distance - curDistance) * curColor.a;
			   }
			}
			
			curColor = texture2D(bitmap, openfl_TextureCoordv);

			float alphaRatio = (totalAlpha / MAX_TOTAL_ALPHA);

			float innerGlowAlpha = (1.0 - alphaRatio) * innerStrength * curColor.a;
			float innerGlowStrength = min(1.0, innerGlowAlpha);
			
			vec4 innerColor = mix(curColor, glowColor, innerGlowStrength);

			float outerGlowAlpha = alphaRatio * outerStrength * (1. - curColor.a);
			float outerGlowStrength = min(1.0 - innerColor.a, outerGlowAlpha);

			vec4 outerGlowColor = outerGlowStrength * glowColor.rgba;
			
			if (knockout) {
			  float resultAlpha = outerGlowAlpha + innerGlowAlpha;
			  gl_FragColor = vec4(glowColor.rgb * resultAlpha, resultAlpha);
			}
			else {
			  gl_FragColor = innerColor + outerGlowColor;
			}
			
			gl_FragColor = gl_FragColor * openfl_Alphav;
		}
		
		"
	)

	/**
	 *  Glow shader. Pixi Port.
	 * @param	color The color of the glow.
	 * @param	distance The distance of the glow. Make it 2 times more for resolution=2.  It can't be changed after filter creation. Maximum 100.
	 * @param	quality A number between 0 and 1 that describes the quality of the glow.  The higher the number the less performant.
	 * @param	knockout Toggle to hide the contents and only show glow.
	 * @param	innerStrength The strength of the glow inward from the edge of the sprite.
	 * @param	outerStrength The strength of the glow outward from the edge of the sprite.
	 */
	public function new(color:Int = 0xffffff, colorAlpha:Float = 1.0, distance:Float = 10.0, quality:Float = 0.1, knockout:Bool = false, innerStrength:Float = .0, outerStrength:Float = 4.) 
	{
		super();
		//distance = Math.round(distance);
		var _color = hex2rgb(color, colorAlpha);
		data.glowColor.value = _color;
		data.distance.value = [distance];
		//data.quality.value = [quality];
        data.knockout.value = [knockout];
		data.innerStrength.value = [innerStrength];
        data.outerStrength.value = [outerStrength];        
	}
	
	public function hex2rgb(hex:Int, alpha:Float)
    {
        var out = [];
        out[0] = ((hex >> 16) & 0xFF) / 255;
        out[1] = ((hex >> 8) & 0xFF) / 255;
        out[2] = (hex & 0xFF) / 255;
        out[3] = alpha;
        return out;
    }
	
}