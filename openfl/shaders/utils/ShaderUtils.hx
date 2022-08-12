package openfl.shaders.utils;

/**
 * Set of tools
 * @author Loudo
 */
class ShaderUtils 
{

	static public function hex2rgb(hex:Int, alpha:Float)
    {
        var out = [];
        out[0] = ((hex >> 16) & 0xFF) / 255;
        out[1] = ((hex >> 8) & 0xFF) / 255;
        out[2] = (hex & 0xFF) / 255;
        out[3] = alpha;
        return out;
    }
	
}