package openfl.shaders;
import openfl.display.GraphicsShader;

/**
 * Inverts the base color
 * @author MrCdK
 * @author adapted by Loudo
 * TODO mask ?
 */
class Invert extends GraphicsShader
{
	
	@:glFragmentSource(
		"#pragma header
		
		void main(void) {
			
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(1.0 - gl_FragColor.r, 1.0 - gl_FragColor.g, 1.0 - gl_FragColor.b, gl_FragColor.a);
			gl_FragColor = gl_FragColor * openfl_Alphav;
			
		}"
	)
	
	public function new()
	{
		super();
	}
}