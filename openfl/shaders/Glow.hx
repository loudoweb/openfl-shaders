package openfl.shaders;

import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;
using StringTools;
using openfl.shaders.utils.ShaderUtils;

/**
 * Glow shader
 * port from Pixi : https://github.com/pixijs/filters/blob/main/filters/glow/src/glow.frag
 * @author adapted by Loudo
 * TODO what's filterClamp??
 */
class Glow extends GraphicsShader 
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform float distance;
		
		uniform float outerStrength;
		uniform float innerStrength;

		uniform vec4 glowColor;

		uniform bool knockout;
		
		const vec4 filterClamp = vec4(0.,0., 20., 20.);

		const float PI = 3.14159265358979323846264;
		
		const float ANGLE_STEP_SIZE = min(__ANGLE_STEP_SIZE__, PI * 2.0);
		const float ANGLE_STEP_NUM = ceil(PI * 2. / ANGLE_STEP_SIZE);
		
		

		void main(void) {
			vec2 px = vec2(1.0 / openfl_TextureSize.x, 1.0 / openfl_TextureSize.y);

			float max_total_alpha = ANGLE_STEP_NUM * distance * (distance + 1.0) / 2.0;
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

			float alphaRatio = (totalAlpha / max_total_alpha);

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
	
	inline public function setDistance(dist:Float):Float
	{
		dist = Math.round(dist);
		data.distance.value = [dist];
		return dist;
	}
	
	/**
	*  Glow shader.
	* @param	color The color of the glow.
	* @param	distance The distance of the glow. Make it 2 times more for resolution=2. Maximum 100.
	* @param	quality A number between 0 and 1 that describes the quality of the glow.  The higher the number the less performant. This can't be changed after. If you plan to animate the distance, set a quality that matches the biggest distance you use.
	* @param	knockout Toggle to hide the contents and only show glow.
	* @param	innerStrength The strength of the glow inward from the edge of the sprite.
	* @param	outerStrength The strength of the glow outward from the edge of the sprite.
	*/
	public function new(color:Int = 0xffffff, colorAlpha:Float = 1.0, distance:Float = 10, quality:Float = 0.1, knockout:Bool = false, innerStrength:Float = .0, outerStrength:Float = 4.) 
	{
		super();
		distance = setDistance(distance);
		//__glFragmentSource = __glFragmentSource.replace("__DIST__", distance.toFixed(0));
		__glFragmentSource = __glFragmentSource.replace("__ANGLE_STEP_SIZE__", (1 / quality / distance).toFixed(7));
				
		var _color = color.hex2rgb(colorAlpha);
		data.glowColor.value = _color;
        data.knockout.value = [knockout];
		data.innerStrength.value = [innerStrength];
        data.outerStrength.value = [outerStrength];   
		
	}
	
}
/**
*  Glow shader.
* @param	color The color of the glow.
* @param	distance The distance of the glow. Make it 2 times more for resolution=2. Maximum 100.
* @param	quality A number between 0 and 1 that describes the quality of the glow.  The higher the number the less performant. This can't be changed after. If you plan to animate the distance, beware that quality may not match.
* @param	knockout Toggle to hide the contents and only show glow.
* @param	innerStrength The strength of the glow inward from the edge of the sprite.
* @param	outerStrength The strength of the glow outward from the edge of the sprite.
* @param	extension By default, the filter set the value of distance. But if you plan to animate the distance, you may need to set a bigger value here.
*/
class GlowFilter extends ShaderFilter{
	public function new(color:Int = 0xffffff, colorAlpha:Float = 1., distance:Float = 10, quality:Float = 0.1, knockout:Bool = false, innerStrength:Float = .0, outerStrength:Float = 4., extension:Int = 0)
	{
		var _shader = new Glow(color, colorAlpha, distance, quality, knockout, innerStrength, outerStrength);
		var _extension:Int = extension == 0 ? Math.ceil(distance*1.2) : extension;
		super(_shader);
		__topExtension = _extension;
		__leftExtension = _extension;
		__rightExtension = _extension;
		__bottomExtension = _extension;
	}
}