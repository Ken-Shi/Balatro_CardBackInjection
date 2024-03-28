# Balatro_CardBackInjection
A Balatro mod dedicated to adding customized card backs to the game in ease. Every mod that follows the same convention will be compatible with each other. 
Special thanks to @JoStro and @Kusoro for helping me along the making of this! 
Version 2.0 storms away all of the known bug and made this extremely robust!!!

# Installation
1. Make sure you have installed [Steamodded](https://github.com/Steamopollys/Steamodded) as it is used for the loading of this module.
2. Download the folder `CardBackInjection` into the mods folder of Steamodded (you can also download the .zip file and unzip there directly, this is mostly for r2mm so there will be extra files. You only really need the folder!) and you are good to go!

Sanity Check: The path should look something like ".../Mods/CardBackInjection"

# Usage
You can use the function `ReadCardBackInfo()` to find your desired cardback via it's name. All of your card back arts of format `b_{cardbackname}.png` will be added to the game. You can write `any_var = ReadCardBackInfo()` at the beginning of your initialization code. You can then use this arbitrary `any_var` to read the position of your own card backs. This mod will initialize itself upon SMODS.INIT, so you don't have to do anything other than getting information to read your cardbacks.  

Please make sure that you prepare a `71x95` version of your `b_{cardbackname}.png` in your `assets/1x/` folder and a `142x190` version of your `b_{cardbackname}.png` in your `assets/2x/` folder for each of your card back to be supported with and without pixel smoothing!  

Currently if you want to use a custom texture pack, you will want to replace the `OGEnhancer.png` in the assets folder of this to your own texture pack. I will be working on getting rid of this step soon! 

# Example
Suppose you have file `b_mycardback.png` in your mod's `assets` folder (either in your mod's folder or in the general Mods folder, for both 1x and 2x), do this at the beginning of your mod init function:

```cardback_info = ReadCardBackInfo()```

you can then simply find the corresponding `sprite` / `spritePos` attribute via

```cardback_info["mycardback"]```

which will look something like `{ x = 2, y = 5 }`, they can be arbitrary value bounded by however deep it gets. 
