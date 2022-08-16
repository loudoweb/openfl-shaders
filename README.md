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
* outline
* Deuteranopia (color blindness)
* DotScreen
* Film Shader
* HueSaturation

## Animations

Animation can be animated by calling an update method


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

