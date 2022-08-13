package openfl.shaders;

import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;
import openfl.shaders.utils.ShaderUtils;
import openfl.utils.ByteArray;

/**
 * Port from Pixi https://github.com/pixijs/filters/blob/main/filters/outline/src/outline.frag
 * @author adapted by loudo
 * TODO what's filterClamp??
 * TODO make ANGLE_STEP a quality parameter. => The quality of the outline from `0` to `1`, using a higher quality setting will result in slower performance and more accuracy.
 */
class Outline extends GraphicsShader 
{
	
	 /** The minimum number of samples for rendering outline. */
    public static var MIN_SAMPLES:Int = 1;

    /** The maximum number of samples for rendering outline. */
    public static var MAX_SAMPLES:Int = 100;
	
	@:glFragmentSource("
	#pragma header

	uniform vec2 thickness;
	uniform vec4 outlineColor;
	const vec4 filterClamp = vec4(0.,0., 20., 20.);

	const float DOUBLE_PI = 3.14159265358979323846264 * 2.;
	const float ANGLE_STEP = .628318;//0.1 is better with big outlines

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
	  * 
	  * @param	thickness The tickness of the outline. Make it 2 times more for resolution 2
	  * @param	color The color of the outline.
	  * @param	colorAlpha The alpha of the outline.
	  */
	public function new(thickness:Float = 1., color:Int = 0x000000, colorAlpha:Float = 1.)
	{
		super();
		
		data.thickness.value = [thickness, thickness];
		var _color = ShaderUtils.hex2rgb(color, colorAlpha);
		data.outlineColor.value = _color;
	}
	/*
	private static getAngleStep(quality: number): string
    {
        const samples =  Math.max(
            quality * OutlineFilter.MAX_SAMPLES,
            OutlineFilter.MIN_SAMPLES,
        );

        return (Math.PI * 2 / samples).toFixed(7);
    }
	*/
	
}
class OutlineFilter extends ShaderFilter{
	public function new(thickness:Float = 1., color:Int = 0x000000, colorAlpha:Float = 1.)
	{
		var _shader = new Outline(thickness, color, colorAlpha);
		var extension:Int = Math.ceil(thickness);
		super(_shader);
		@:privateAccess this.__topExtension = extension;
		@:privateAccess this.__leftExtension = extension;
		@:privateAccess this.__rightExtension = extension;
		@:privateAccess this.__bottomExtension = extension;
	}
}