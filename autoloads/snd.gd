extends Node

# List of the few sounds we'll play in this game
var sounds: Dictionary = {
	"splodey": {
		"path": "res://audio/GWJ81_explosion.ogg",
		"stream": load("res://audio/GWJ81_explosion.ogg"),
		"player": null,
		"count": 0
	},
	"crash": {
		"path": "res://audio/GWJ81_Explosion2.ogg",
		"stream": load("res://audio/GWJ81_Explosion2.ogg"),
		"player": null,
		"count": 0
	},
	"click": {
		"path": "res://audio/GWJ81_click.ogg",
		"stream": load("res://audio/GWJ81_click.ogg"),
		"player": null,
		"count": 0
	},
	"alert": {
		"path": "res://audio/GWJ81_alert.ogg",
		"stream": load("res://audio/GWJ81_alert.ogg"),
		"player": null,
		"count": 0
	},
	"light_cannon": {
		"path": "res://audio/GWJ81_shoot2.ogg",
		"stream": load("res://audio/GWJ81_shoot2.ogg"),
		"player": null,
		"count": 0
	},
	"heavy_cannon": {
		"path": "res://audio/GWJ81_shoot1.ogg",
		"stream": load("res://audio/GWJ81_shoot1.ogg"),
		"player": null,
		"count": 0
	}
}

# Sound players yay!
func initialize(scene_tree: SceneTree):
	# Let's create a few sound players and add them to the specified scene tree
	for k in sounds.keys():
		var plyr = AudioStreamPlayer.new()
		plyr.stream = sounds[k].stream
		scene_tree.root.add_child.call_deferred(plyr)
		sounds[k].player = plyr

# Play a sound!
func play(snd: String):
	# Is snd a key in our dictionary?
	if sounds.has(snd):
		# It does, play the sound
		sounds[snd].player.play()
		# Here's some shenanigans I have to do to make the sound players work right in HTML5
		# https://forum.godotengine.org/t/audio-gets-quieter-the-more-a-source-is-played-in-browser-build/80375/3
		sounds[snd].count += 1
		if sounds[snd].count > 25:
			sounds[snd].player.stream = load(sounds[snd].path)
			sounds[snd].count = 0
		
