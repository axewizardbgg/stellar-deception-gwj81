extends Node2D

signal show_event(event: Dictionary)

# Expected to be set by _ready()
var level: int = 1 # Used to help determine interval between events for our Timer

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Set our timer's wait_time and start it
	$Timer.wait_time = 20 - (float(level) / 2)
	$Timer.start()
	
	# Connect signal
	$Timer.timeout.connect(_show_event)

# Signal connector function
func _show_event():
	# Are there currently any enemies? (Don't bother the player with events when they're fighting)
	if is_instance_valid(get_tree().get_first_node_in_group("enemies")):
		# Yes, player is currently fighting, do nothing
		return
	
	# Player is not fighting, it's ok to show an event
	emit_signal("show_event", {})

# Sometimes we want to spawn an individual event
func spawn_special_event(kind: String):
	# What kind of event are we spawning?
	match kind:
		"enemy_destroyed":
			emit_signal("show_event", special_events.enemy_destroyed)
		"enemy_lost":
			emit_signal("show_event", special_events.enemy_lost)
	
	# Restart our timer
	$Timer.start()
			

var special_events: Dictionary = {
	"enemy_destroyed": {
		"description": "You have disabled your attacker! You run scans on the disabled ship, and there are still signs of life.",
		"choices": [
			{
				"description": "Board and loot the ship.",
				"result": "You order the crew to board and salvage whatever they can find, and quickly. They are met with some scattered resistance and some of your crew are wounded, but they make short work of surviving combatants and quickly loot the vessel. While the boarders were looting, engineers worked to repair some of the immediate damage on your ship. When asked what to do about the survivors, you ordered them left aboard the ship, with some food. That's all the mercy you can afford in the endless void of space.",
				"effect_ship": 5,
				"effect_crew": -5,
				"effect_cash": 5,
				"other_effects": {
					"repair": 25,
				},
			},
			{
				"description": "Leave before more show up.",
				"result": "You resume your course and leave the disabled vessel behind, and the crew cheers at the victory. You briefly entertained the idea of boarding and looting, but you had a gut feeling that you needed to get out of here. You live another day, and that's all that matters out here in the infinite abyss that is space.",
				"effect_ship": 0,
				"effect_crew": +8,
				"effect_cash": 0,
			},
		]
	},
	"enemy_lost": {
		"description": "Your sensors are no longer reading a threat from the enemy ship.",
		"choices": [
			{
				"description": "Good, resume course to your destination.",
				"result": "You set a course and resume your expedition. The crew celebrates when you give the all-clear.",
				"effect_ship": 0,
				"effect_crew": +5,
				"effect_cash": 0,
			},
			{
				"description": "Turn about and re-engage the enemy.",
				"result": "You order the crew back to battle stations and head back in the direction you came. It's time to engage these bastards on your own terms.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
				"other_effects": {
					"re-engage": "",
				},
			},
		]
	},
}
