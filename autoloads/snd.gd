extends Node

# List of the few sounds we'll play in this game
var sounds: Dictionary = {
	"splodey": {
		"stream": "res://audio/GWJ81_explosion.ogg",
		"player": null
	},
	"crash": {
		"stream": "res://audio/GWJ81_Explosion2.ogg",
		"player": null
	},
	"click": {
		"stream": "res://audio/GWJ81_click.ogg",
		"player": null
	},
	"alert": {
		"stream": "res://audio/GWJ81_alert.ogg",
		"player": null
	},
	"light_cannon": {
		"stream": "res://audio/GWJ81_shoot2.ogg",
		"player": null
	},
	"heavy_cannon": {
		"stream": "res://audio/GWJ81_shoot1.ogg",
		"player": null
	}
}

# Sound players yay!
func initialize(scene_tree: SceneTree):
	# Let's create a few sound players and add them to the specified scene tree
	for k in sounds.keys():
		var plyr = AudioStreamPlayer.new()
		plyr.stream = load(sounds[k].stream)
		scene_tree.root.add_child.call_deferred(plyr)
		sounds[k].player = plyr

# Play a sound!
func play(snd: String):
	# Is snd a key in our dictionary?
	if sounds.has(snd):
		# It does, play the sound
		sounds[snd].player.play()
