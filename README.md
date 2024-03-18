# Balatro_CardBackInjection
A Balatro mod dedicated to adding customized card backs to the game in ease. Every mod that follows the same convention will be compatible with each other. 

# Installation
1. Make sure you have installed steamodded as it is used for the loading of this module.
2. Download the `assets` and `CardBackInjection.lua` into the mods folder of steamodded and you are good to go!

# Usage
This mod defines a function `InjectCardBack()` that concatenates all of your card back arts of format `b_{cardbackname}.png` to the game. You can use `G.cardback_info` to read the position of your own card backs. 

# Example
Suppose you have file `b_mycardback.png` in `assets` folder (for both 1x and 2x), you can simply find the corresponding `sprite` / `spritePos` attribute via
```G.cardback_info["mycardback"]```
which will look something like `{ x = 2, y = 5 }`, they can be arbitrary value bounded by however deep it gets. 
