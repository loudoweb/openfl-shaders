package openfl.shaders.blendMode;
import openfl.display.BitmapData;
import openfl.display.GraphicsShader;

/**
 * Replaces the hue and saturation of the base color by the ones of the blend color. Useful for tinting color images.
 * @author hsv convertion from https://newbedev.com/from-rgb-to-hsv-in-opengl-glsl
 * @author Loudo
 */
class Color extends GraphicsShader
{
	
	@:glFragmentSource(
		"#pragma header
		
		uniform sampler2D foreground;
		
		
		vec3 rgb2hsv(vec3 c)
		{
			vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
			vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}
		
		vec3 hsv2rgb(vec3 c)
		{
			vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}

		vec3 blendColor(vec3 base, vec3 blend) {
			vec3 hsvBase = rgb2hsv(base);
			vec3 hsvBlend = rgb2hsv(blend);
			hsvBlend.z = hsvBase.z;
			return hsv2rgb(hsvBlend);
		}

		vec3 blendColor(vec3 base, vec3 blend, float opacity) {
			return (blendColor(base, blend) + base * (1.0 - opacity));
		}
		
		void main(void) {
			
			vec4 bgColor = texture2D(bitmap, openfl_TextureCoordv);
			vec4 fgColor = texture2D(foreground, openfl_TextureCoordv);
			vec3 blendedColor = blendColor(bgColor.rgb, fgColor.rgb, fgColor.a);
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