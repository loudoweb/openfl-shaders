package openfl.shaders;

import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;
using openfl.shaders.utils.ShaderUtils;
using StringTools;

/**
 * Outline shader.
 * Port from Pixi https://github.com/pixijs/filters/blob/main/filters/outline/src/outline.frag
 * @author adapted by loudo
 * TODO what's filterClamp??
 */
class Outline extends GraphicsShader 
{
	
	inline public static var DOUBLE_PI:Float = 3.14159265358979323846264 * 2.;
	 /** The minimum number of samples for rendering outline. */
    inline public static var MIN_SAMPLES:Int = 1;

    /** The maximum number of samples for rendering outline. */
    inline public static var MAX_SAMPLES:Int = 100;
	
	@:glFragmentSource("
	#pragma header

	uniform vec2 thickness;
	uniform vec4 outlineColor;
	const vec4 filterClamp = vec4(0.,0., 20., 20.);

	const float DOUBLE_PI = 3.14159265358979323846264 * 2.;
	const float ANGLE_STEP = __ANGLE_STEP__;

	void main(void) {
		vec4 ownColor = texture2D(bitmap, openfl_TextureCoordv);
		vec4 curColor;
		vec2 newThickness = vec2(thickness.x / openfl_TextureSize.x, thickness.y / openfl_TextureSize.y);
		float maxAlpha = 0.;
		vec2 displaced;
		for (float angle = 0.; angle <= DOUBLE_PI; angle += ANGLE_STEP) {
			displaced.x = openfl_TextureCoordv.x + newThickness.x * cos(angle);
			displaced.y = openfl_TextureCoordv.y + newThickness.y * sin(angle);
			curColor = texture2D(bitmap, clamp(displaced, filterClamp.xy, filterClamp.zw));
			maxAlpha = max(maxAlpha, curColor.a);
		}
		float resultAlpha = max(maxAlpha, ownColor.a);
		gl_FragColor = vec4((ownColor.rgb + outlineColor.rgb * (1. - ownColor.a)) * resultAlpha, resultAlpha);
		
		gl_FragColor = gl_FragColor * openfl_Alphav;
	}
	
	
	")
	/**
	* Outline Shader.
	* @param	thickness The tickness of the outline. Make it 2 times more for resolution 2
	* @param	color The color of the outline.
	* @param	colorAlpha The alpha of the outline.
	* @param	quality between 0 and 1. Higher is better but less performant. Can't be changed after, so if you plan to change the thickness, set the quality that works best with the higher thickness.
	*/
	public function new(thickness:Float = 1., color:Int = 0x000000, colorAlpha:Float = 1., quality:Float = 0.1)
	{
		super();
		
		__glFragmentSource = __glFragmentSource.replace("__ANGLE_STEP__", (DOUBLE_PI / (Math.max(quality * MAX_SAMPLES, MIN_SAMPLES))).toFixed(7));
		
		data.thickness.value = [thickness, thickness];
		var _color = color.hex2rgb(colorAlpha);
		data.outlineColor.value = _color;
	}
	
}
/**
* Outline Shader.
* @param	thickness The tickness of the outline. Make it 2 times more for resolution 2
* @param	color The color of the outline.
* @param	colorAlpha The alpha of the outline.
* @param	quality between 0 and 1. Higher is better but less performant. Can't be changed after, so if you plan to change the thickness, set the quality that works best with the higher thickness.
*/
class OutlineFilter extends ShaderFilter{
	public function new(thickness:Float = 1., color:Int = 0x000000, colorAlpha:Float = 1., quality:Float = 0.1)
	{
		var _shader = new Outline(thickness, color, colorAlpha, quality);
		var extension:Int = Math.ceil(thickness);
		super(_shader);
		__topExtension = extension;
		__leftExtension = extension;
		__rightExtension = extension;
		__bottomExtension = extension;
	}
}