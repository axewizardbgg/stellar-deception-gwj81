extends Control

signal bars_changed(new_values: Dictionary)
signal destination_selected(d_id: String)
signal other_effect(kind: String, value)

# Expected to be set before _ready
var bar_values: Dictionary = {
	"ship": 0.0,
	"crew": 0.0,
	"cash": 0.0
}
var location_data: Dictionary = {
	"title": "",
	"desc": "",
	"destinations": []
}

# References to the various UI elements we'll need to manage.
@onready var main_ui: Control = $MainUI
@onready var result_ui: Control = $ResultUI
@onready var destination_ui: Control = $DestinationUI
@onready var location_title: Label = $MainUI/MC/VBC/Title
@onready var location_desc: Label = $MainUI/MC/VBC/Description
@onready var choices_left: Label = $MainUI/MC/VBC/HBC/VBC/ChoicesLeft
@onready var choices_vbc: VBoxContainer = $MainUI/MC/VBC/HBC/VBC/ScrollContainer/ChoicesVBC
@onready var main_ship_bar: ProgressBar = $MainUI/MC/VBC/HBC/VBC2/ShipBar
@onready var main_crew_bar: ProgressBar = $MainUI/MC/VBC/HBC/VBC3/CrewBar
@onready var main_cash_bar: ProgressBar = $MainUI/MC/VBC/HBC/VBC4/CashBar
@onready var result: Label = $ResultUI/CC/VBC/Result
@onready var result_ship_bar: ProgressBar = $ResultUI/CC/VBC/HBC/ShipBar
@onready var result_crew_bar: ProgressBar = $ResultUI/CC/VBC/HBC2/CrewBar
@onready var result_cash_bar: ProgressBar = $ResultUI/CC/VBC/HBC3/CashBar
@onready var result_proceed: Button = $ResultUI/CC/VBC/Proceed
@onready var destination_hbc: HBoxContainer = $DestinationUI/MC/VBC/HBC

# Other stuff
var choices: Array = [] # Will be populated in _ready()
var num_choices: int = 3

# Called when the node enters the scene for the first time
func _ready() -> void:
	_reset_main_ui(true)

# Helper function to set up the main UI (upon first visit, as well returning from result window)
func _reset_main_ui(first_time: bool = false):
	# Set visibility stuff
	result_ui.visible = false
	destination_ui.visible = false
	main_ui.visible = true
	
	# Clear out any existing choices buttons
	var old_choice_buttons: Array = choices_vbc.get_children()
	for button in old_choice_buttons:
		button.queue_free()
	
	# Let's initialize our UI values
	location_title.text = location_data.title
	location_desc.text = location_data.desc
	
	# Is it our first time loading this screen since we've been added to the scene tree?
	if first_time:
		# It is, we need to generate 7 random choices
		choices = MapInfo.get_random_choices(7)
		
		# Also while we're at it, let's set up our Destination UI as well
		_prepare_destination_buttons()
	
	# Prepare the choices
	_prepare_choice_buttons()
	
	# Set our progress bars
	main_ship_bar.value = bar_values.ship
	main_crew_bar.value = bar_values.crew
	main_cash_bar.value = bar_values.cash
	
	# Now that we've set up our UI, let's set the alpha to 0 and use a tween to fade it in.
	main_ui.modulate.a = 0
	main_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE # Give it a moment before we can click anything
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(main_ui, "modulate:a", 1, 1)
	tween.tween_callback(func (): main_ui.mouse_filter = Control.MOUSE_FILTER_STOP)

# Helper function to create the choice buttons
func _prepare_choice_buttons() -> void:
	# For each choice, we'll create a button that shows the info about it, and add
	# it to our UI, and connect the signal
	# Each choice is a dictionary of this shape:
	#{
		#"title": "",
		#"description": "",
		#"result": "",
		#"effect_ship": 0.0,
		#"effect_crew": 0.0,
		#"effect_cash": 0.0,
		#"other_effects": {
			#"max_hull": 0.0
		#}
	#},
	for i in choices.size():
		# Let's build the text first (not the cleanest way to do it, but it's readable, whatever)
		var button_text: String = choices[i].title
		button_text += "\n\n"
		button_text += choices[i].description
		button_text += "\n\n"
		#var sign: String = "+"
		#if choices[i].effect_ship < 0:
			#sign = "-"
		button_text += "Ship: " + str(choices[i].effect_ship) + "     "
		button_text += "Crew: " + str(choices[i].effect_crew) + "     "
		button_text += "Cash: " + str(choices[i].effect_cash)
		
		# Button text is prepared, now let's make the button
		var choice_button: Button = Button.new()
		choice_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		choice_button.text = button_text
		
		# Add it to our UI
		choices_vbc.add_child(choice_button)
		
		# Connect signal
		choice_button.pressed.connect(_choice_clicked.bind(i))

# Helper function to prepare the Destination buttons at the end
func _prepare_destination_buttons() -> void:
	# First, clear any buttons I already had there
	var old_btns: Array = destination_hbc.get_children()
	for old_btn in old_btns:
		old_btn.queue_free()
	# Here's the shape of a location:
	#{
		#"d_id": "00a",
		#"name": "",
		#"spr_path": "",
		#"description": "",
		#"distance": "",
		#"danger": "",
		#"destinations": [
			#"00b",
		#]
	#},
	# Iterate through each destination and create a button for it
	for dest in location_data.destinations:
		# Prepare the button text
		var btn_text: String = MapInfo.list[dest].name + "\n\n"
		btn_text += MapInfo.list[dest].description + "\n\n"
		btn_text += "Distance: " + MapInfo.list[dest].distance
		
		# Create the button and set the text, and add it to the scene
		var btn: Button = Button.new()
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD
		btn.text = btn_text
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		destination_hbc.add_child(btn)
		
		# Connect the signal
		btn.pressed.connect(_destination_clicked.bind(dest))

# Signal connector function for when the user selects a destination
func _destination_clicked(d_id: String):
	# Emit signal of our selection, and destroy ourselves
	emit_signal("destination_selected", d_id)
	Snd.play("click")
	queue_free()

# Signal connector function for when the user selects a choice
func _choice_clicked(choice_index: int):
	# Player has selected a choice! Hide the main ui
	main_ui.visible = false
	
	# Set the result ui to be visible, but also not visible (lol makes total sense right?)
	result_ui.visible = true
	result_ui.modulate.a = 0
	result_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE # Avoid player accidentally clicking stuff
	
	# Set the result text and the proceed button to be disabled
	result.text = choices[choice_index].result
	result_proceed.disabled = true
	
	# Set the values of the bars (to the old/current values for now)
	result_ship_bar.value = bar_values.ship
	result_crew_bar.value = bar_values.crew
	result_cash_bar.value = bar_values.cash
	
	# Apply the changes to the bars (we'll tween the actual values of the bar later)
	bar_values.ship += choices[choice_index].effect_ship
	bar_values.crew += choices[choice_index].effect_crew
	bar_values.cash += choices[choice_index].effect_cash
	emit_signal("bars_changed", bar_values)
	
	# Ensure changes are within bounds (iterate through each key in the dictionary)
	for key in bar_values.keys():
		# Upper boundary
		if bar_values[key] > 100:
			bar_values[key] = 100
		# Lower boundary
		if bar_values[key] < 0:
			bar_values[key] = 0
	
	# Does this choice have any other effects? Emit signals for any additional effects
	if choices[choice_index].has("other_effects"):
		for k in choices[choice_index].other_effects.keys():
			emit_signal("other_effect", k, choices[choice_index].other_effects[k])
	
	# Set a Tween so we can fade in the alpha (and also re-enabling the ability for the player to click on stuff)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(result_ui, "modulate:a", 1, 1)
	tween.tween_callback(_result_ui_shown)
	
	# Eliminate the choice from not only our set of choices, but the main list as well
	MapInfo.remove_choice_by_title(choices[choice_index].title)
	choices.remove_at(choice_index)
	
	# Decrement our counter for how many choices we have left
	num_choices -= 1
	choices_left.text = "(" + str(num_choices) + " choices remaining)"
	
	# Play sound
	Snd.play("click")

func _result_ui_shown():
	# Allow the player to click things again
	result_ui.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Tween the changes to the bars (and enable the Proceed button once the tween is done)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(result_ship_bar, "value", bar_values.ship, 0.5)
	tween.tween_property(result_crew_bar, "value", bar_values.crew, 0.5)
	tween.tween_property(result_cash_bar, "value", bar_values.cash, 0.5)
	tween.tween_callback(func(): result_proceed.disabled = false)


# Signal Connector function that was hooked up from the Node inspector panel
func _on_proceed_pressed() -> void:
	# Do we have any choices left to make?
	if num_choices > 0:
		# Yes we do, reset the UI
		_reset_main_ui()
		return
	
	# No we do not, we need to display the destination UI
	destination_ui.visible = true
	result_ui.visible = false
	
	# Let's set the alpha to 0 and use a tween to fade it in.
	destination_ui.modulate.a = 0
	destination_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE # Give it a moment before we can click anything
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(destination_ui, "modulate:a", 1, 1)
	tween.tween_callback(func (): destination_ui.mouse_filter = Control.MOUSE_FILTER_STOP)
