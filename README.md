# openfl-shaders
Shaders for your openfl Sprites

## Blend Modes

Blend modes use a BitmapData as a blend texture

* Overlay `sprite.shader = new openfl.shaders.blendMode.Overlay(Assets.getBitmapData("foreground.png"));`
* Difference
* Color Dodge
* Color Burn
* Glow
* Screen
* Hue
* Saturation
* Color
* Exclusion
* Darken
* Lighten
* Vivid Light
* Hard Light
* Soft Light
* Reflect
* Negation
* Multiply
* AlphaMask

## Effects

Various effects

* Glow
* GrayScale
* Outline
* Deuteranopia (color blindness)
* DotScreen
* Film Shader
* HueSaturation

## Animations

Animation can be animated by calling an update method

* Electric (animated blue noise): LICENSE CC-BY-SA 3.0
* Shaker
* Swell (animated underwater?)


## TODO

* use **gl_FragColor** instead of original bitmap texture when possible so all these shaders can be mixed together with colorTransform and filters, etc.

### blend modes

* ERASE				


### Effects

* Blur
* GBA
* Glitch
* Pixelate

### Light

* NormalMap
* PointLight

### animations 

* Erode
* Dissolve
* Color Remove
* RGB scale
* Pixel Wipe
* Blur swap
* Bubble
* ...

### test

* Tilemap


## Contributions

To help make shaders to OpenFl. First if you want to port a shader, check the license (this repo is MIT, but we can still use other free license as soon as we specify it in the shader comment). Then please note that we are using glsl (version 120 I guess).
Finally, here are the openfl internal variables:
	
	```haxe
	varying vec2 openfl_TextureCoordv;//could be vTextureCoord in other shaders
	uniform vec2 openfl_TextureSize;//
	uniform sampler2D bitmap;//usually you should use the resulting gl_FragColor, but if needed replace the main sampler2D by bitmap
	varying float openfl_Alphav;//multiply FragColor by this to use your sprite.alpha value.
	```
	
You should also use `#pragma header` in the header of your shader to help openfl injects its internal variables. And then `#pragma body` in the top of your main function, to let openfl calculate its stuffs (e.g: colorTrans
).

Some bugs you may encounter:
	
	* Floating-point suffix unsupported prior to GLSL ES 3.00 => Just remove the f at the end of float numbers.
	* You need to use constant values in your for loop instructions
