extends CanvasLayer

signal bars_changed(new_values: Dictionary)
signal o_effect(kind: String, value)

# Will be set if needed before _ready by the calling instance
var special_event: Dictionary

# Various UI nodes I'll need to easily reference
@onready var choice_ui: Control = $Choices
@onready var result_ui: Control = $Result
@onready var desc: Label = $Choices/CC/VBC/Description
@onready var choice1: Button = $Choices/CC/VBC/Choice1
@onready var choice2: Button = $Choices/CC/VBC/Choice2
@onready var result: Label = $Result/CC/VBC/Result
@onready var bar_ship: ProgressBar = $Result/CC/VBC/HBC/Ship
@onready var bar_crew: ProgressBar = $Result/CC/VBC/HBC2/Crew
@onready var bar_cash: ProgressBar = $Result/CC/VBC/HBC3/Cash
@onready var change: Label = $Result/CC/VBC/Change
@onready var proceed: Button = $Result/CC/VBC/Continue

# Expected to be set before _ready
var bar_values: Dictionary = {
	"ship": 0.0,
	"crew": 0.0,
	"cash": 0.0
}

# Other stuff
var event: Dictionary # Will be set in _ready
var other_effects: Dictionary # May be set during choice selection if a choice has other effects

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# First things first, let's pause the game! (We can still process, but not the rest of the game)
	get_tree().paused = true
	
	# Load our sound into our snd player and play it (I do this manually for HTML5 quirks...)
	$AudioStreamPlayer.stream = load("res://audio/GWJ81_Location.mp3")
	$AudioStreamPlayer.play()
	
	# Now, are we showing a special event, or a random one?
	if special_event.is_empty():
		# Random event
		event = MapInfo.get_random_event()
	else:
		# Special event!
		event = special_event
	
	# Here's the shape of an event dictionary:
	"""
	{
		"e_id": "",
		"description": "",
		"choices": [
			{
				"description": "",
				"result": "",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": [
					{
						"TODO": "",
					},
				]
			},
		]
	},
	"""
	
	# Update our UI
	desc.text = event.description
	choice1.text = event.choices[0].description
	choice2.text = event.choices[1].description
	
	# Connect the signals
	choice1.pressed.connect(_choice_clicked.bind(0))
	choice2.pressed.connect(_choice_clicked.bind(1))
	
	# Finally, let's tween a fade in and also stop input for a moment
	choice_ui.modulate.a = 0
	choice_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE # Give it a moment before we can click anything
	var tween: Tween = create_tween()
	tween.tween_property(choice_ui, "modulate:a", 1, 1)
	tween.tween_callback(func (): choice_ui.mouse_filter = Control.MOUSE_FILTER_STOP)

# Signal connector function for when the player clicks a choice button
func _choice_clicked(idx: int):
	# First let's switch to the Result UI
	choice_ui.visible = false
	result_ui.visible = true
	
	# Update the result and change summary labels
	result.text = event.choices[idx].result
	var summary: String = "Ship: "
	if event.choices[idx].effect_ship > -0.1:
		summary += "+"+str(event.choices[idx].effect_ship)
	else:
		summary += str(event.choices[idx].effect_ship)
	if event.choices[idx].effect_crew > -0.1:
		summary += "   Crew: +"+str(event.choices[idx].effect_crew)
	else:
		summary += "   Crew: "+str(event.choices[idx].effect_crew)
	if event.choices[idx].effect_cash > -0.1:
		summary += "   Cash: +"+str(event.choices[idx].effect_cash)
	else:
		summary += "   Cash: "+str(event.choices[idx].effect_cash)
	change.text = summary
	
	# Initialize the progress bar values before we tween them
	bar_ship.value = bar_values.ship
	bar_crew.value = bar_values.crew
	bar_cash.value = bar_values.cash
	
	# Apply the effects of the choice
	bar_values.ship += event.choices[idx].effect_ship
	bar_values.crew += event.choices[idx].effect_crew
	bar_values.cash += event.choices[idx].effect_cash
	
	# Ensure changes are within bounds (iterate through each key in the dictionary)
	for key in bar_values.keys():
		# Upper boundary
		if bar_values[key] > 100:
			bar_values[key] = 100
		# Lower boundary
		if bar_values[key] < 0:
			bar_values[key] = 0
	
	# Do we have any other effects?
	if event.choices[idx].has("other_effects"):
		other_effects = event.choices[idx].other_effects
	
	# Play sound
	Snd.play("click")
	
	# Tween the changes to the bars (and enable the Proceed button once the tween is done)
	var tween: Tween = create_tween()
	tween.tween_property(bar_ship, "value", bar_values.ship, 0.5)
	tween.tween_property(bar_crew, "value", bar_values.crew, 0.5)
	tween.tween_property(bar_cash, "value", bar_values.cash, 0.5)
	tween.tween_callback(func(): proceed.disabled = false)
	


# Signal connected via the node inspector window
func _on_continue_pressed() -> void:
	# Now that we've done all this stuff, let's unpause the game
	get_tree().paused = false
	
	# Now that main can process again, let's emit signals to it
	emit_signal("bars_changed", bar_values)
	
	# Did we have any other effects we needed to handle?
	if !other_effects.is_empty():
		# We do, emit a signal for each one
		for key in other_effects.keys():
			emit_signal("o_effect", key, other_effects[key])
	
	# Play sound
	Snd.play("click")
	
	# Finally, destroy ourselves
	queue_free()
