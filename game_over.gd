extends Control

signal go_to_menu

# Expected to be set before _ready
var cause: String = "hull" # "ship", "crew", "cash", and "win" are options too

# Descriptions of why you failed lol
var descs: Dictionary = {
	"hull": "Unable to withstand the onslaught of enemy ships and asteroids, your beloved ship is now your funeral pyre for you and your crew. I would say it was glorious... but in reality you exploded in the middle of nowhere, and no one will miss you...",
	"ship": "You've failed to maintain your ship and now you're adrift in space without any life support or enviro systems... You huddle with the crew and enjoy your final minutes together as the oxygen depletes and you all become one with the void...",
	"crew": "You've learned an important lesson far too late: Without your crew, you are nothing. The rigors of your breakneck slapdash journey to the ends of space without a care for the crew has finally come to a head. Mutiny! The crew jettison both you and your cursed cargo out into space...",
	"cash": "No matter how fast your ship is, or how great of a crew you have... it all means nothing if you cannot afford to maintain or vessel or pay your crew. Your navigation subscription lapsed due to a failed payment, and now you're drifting endlessly through space...",
	"win": "After many weeks of constant duress, you and your crew have done it! You finally land on the Alien Homeworld, and your contact is waiting for you. You deliver the sealed package and your receive payment immediately, and the first thing you do is give a huge bonus to your crew! You board your beloved ship and begin the journey home...\n\nSuddenly alarms are blaring, all sensors are spiked, and your ship is rocked violently... as your ship spins violently around you see the giant mushroom cloud... what was in that package? Were you the cause of this? For some reason those are the questions that come to mind as the inferno takes you."
}

# UI elements I'll need to manage
@onready var img_fail: TextureRect = $CenterContainer/HBoxContainer/DeadBro
@onready var img_win: TextureRect = $CenterContainer/HBoxContainer/Win
@onready var title: Label = $CenterContainer/HBoxContainer/VBoxContainer/Title
@onready var desc: Label = $CenterContainer/HBoxContainer/VBoxContainer/Description

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Did we win?
	if cause == "win":
		# We did, congrats! You monster... Show the right image and update the title
		img_fail.visible = false
		img_win.visible = true
		title.text = "You did it! How could you?"
	
	# Update our description label
	desc.text = descs[cause]
	
	# Fade in
	modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE # Give it a moment before we can click anything
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)
	tween.tween_callback(_callback)

func _callback():
	mouse_filter = Control.MOUSE_FILTER_STOP
	$CenterContainer/HBoxContainer/VBoxContainer/Button.disabled = false

func _on_button_pressed() -> void:
	emit_signal("go_to_menu")
	queue_free()
