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
	
	static public function toFixed(f:Float, decimal:Int):String
	{
		var precision:Int = Std.int(Math.pow(10, decimal));
		var p = Math.round(f * precision);
		var f2 = p / precision;
		var str = Std.string(f2);
		if (str.indexOf('.') == -1 )
		{
			return str + ".0";
		}else{
			return str;
		}
	}
	
}