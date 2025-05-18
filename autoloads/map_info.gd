extends Node

# OK MY BAD, this autoload kinda blew up in scope. Originally I was thinking of everything would be
# tied to the locations, but after intitial playtesting I realized that was a stupid idea... so I
# broke out the Choices into their own variable on here, and then also added in Events too...
# I know I'm stupid, get rekt nerds, don't @ me

# List of all the locations and the specifics of those locations
var list: Dictionary = {
	"00": {
		"d_id": "00",
		"name": "Starter Planet",
		"spr_path": "res://sprites/GWJ81_Planet_6.png",
		"description": "Not needed here",
		"distance": "Close",
		"destinations": [
			"01",
		]
	},
	"01": {
		"d_id": "01",
		"name": "Golarion V",
		"spr_path": "res://sprites/GWJ81_Planet1_b.png",
		"description": "Considered by many to be the epicentre of the human sciences, due not only to the diverse and rich environs of the planet itself, but also due to its' close proximity to Alien space.",
		"distance": "Close",
		"destinations": [
			"02a",
			"02b",
		]
	},
	"02a": {
		"d_id": "02a",
		"name": "Vercault",
		"spr_path": "res://sprites/GWJ81_Planet1_b.png",
		"description": "Vercault is one of the longest-standing military outposts near Alien space. It hosts a large defense fleet which has been rather restless since the recent peace with the Aliens.",
		"distance": "Close",
		"destinations": [
			"03a",
			"03b",
		]
	},
	"02b": {
		"d_id": "02b",
		"name": "Truncord Station",
		"spr_path": "res://sprites/GWJ81_SpaceStation1_b.png",
		"description": "This space station broadcasts cryptopackets to all the fringe worlds, and it also encodes and decodes alien-bound communication traffic.",
		"distance": "Average",
		"destinations": [
			"03b",
			"03a",
		]
	},
	"03a": {
		"d_id": "03a",
		"name": "Sunder",
		"spr_path": "res://sprites/GWJ81_Planet_7.png",
		"description": "The most notable feature of this planet is the GIANT FREAKING SPIKE that is rammed through it. No one know how such a thing happened, some suspect it was the Aliens, however they say it was there before them. Unsurprisingly it is a dead planet, yet still attracts many researchers and scientists, and as such there is a lively space station in orbit.",
		"distance": "Far",
		"destinations": [
			"04a",
			"04b"
		]
	},
	"03b": {
		"d_id": "03b",
		"name": "Petriclus II",
		"spr_path": "res://sprites/GWJ81_Planet_8.png",
		"description": "Most of the planet resembles that of other gas giants, however the top of the planet is not only habitable, but a paradise for humans. Most of it is by invitation only, as it is a private getaway for the rich, however there is a port that is open to all.",
		"distance": "Average",
		"destinations": [
			"04a",
			"04b"
		]
	},
	"04a": {
		"d_id": "04a",
		"name": "Goliath III",
		"spr_path": "res://sprites/GWJ81_SpaceStation2_b.png",
		"description": "The final frontier of human-controlled space, this is the largest space station that you've ever seen. The defense fleet maintains their defensive flight patterns despite the peace with the Aliens.",
		"distance": "Far",
		"destinations": [
			"05a",
		]
	},
	"04b": {
		"d_id": "04b",
		"name": "Obscurus VII",
		"spr_path": "res://sprites/GWJ81_Planet_4.png",
		"description": "This mysterious planet lies at the edge of human-controlled space. At first glance it appears to be an uninhabitable gas giant, however once you penetrate the storm clouds there are life forms. Many terrarformers, colinists, and scientists reside here, and there are many ports in orbit.",
		"distance": "Average",
		"destinations": [
			"05a",
		]
	},
	"05a": {
		"d_id": "05a",
		"name": "Axe Wizard",
		"spr_path": "res://sprites/GWJ81_Planet_3.png",
		"description": "The first Alien planet, and the gateway into Alien space. Since the peace, trade has been prosperous and many intrepid traders travel freely through both Alien and Human space. No one can pronounce the name of this planet, but Humans have taken to calling it 'Axe Wizard'... what an odd name. There's a small Human port where you can resupply.",
		"distance": "Far",
		"destinations": [
			"06a",
			"06b"
		]
	},
	"06a": {
		"d_id": "06a",
		"name": "Nes'Qvik'Gud",
		"spr_path": "res://sprites/GWJ81_Planet_5.png",
		"description": "A barren Alien planet, that for some reason still has a large and thriving space port.",
		"distance": "Close",
		"destinations": [
			"07a",
			"07b"
		]
	},
	"06b": {
		"d_id": "06b",
		"name": "Cha'Kee'Milk",
		"spr_path": "res://sprites/GWJ81_Planet_6.png",
		"description": "One of the only known Alien worlds that could be inhabitable by Humans. In light of that, it boasts not only a thriving space port, but many services on the surface as well.",
		"distance": "Far",
		"destinations": [
			"07a",
			"07b"
		]
	},
	"07a": {
		"d_id": "07a",
		"name": "Bowf'Uh'Deez",
		"spr_path": "res://sprites/GWJ81_Planet1_b.png",
		"description": "This Alien world's environment is terrifying hostile to Humans, yet it has a decent space port, and you hear it's a good place to get rare Nuts.",
		"distance": "Average",
		"destinations": [
			"08",
		]
	},
	"07b": {
		"d_id": "07b",
		"name": "Gud'Eiy'Myt",
		"spr_path": "res://sprites/GWJ81_Planet_8.png",
		"description": "This Alien world's surface has strange quirks. Sometimes things are upside-down or down-under. Best stick to the modest space port.",
		"distance": "Close",
		"destinations": [
			"08",
		]
	},
	"08": {
		"d_id": "08",
		"name": "Vik'Tor'Ree",
		"spr_path": "res://sprites/GWJ81_Planet2_b.png",
		"description": "Your ultimate destination you've been trying to reach for so long. The Alien Homeworld. Your expedition is almost at an end.",
		"distance": "Far",
		"destinations": []
	},
}

# Template for the locations list entries
"""
	"00a": {
		"d_id": "00a",
		"name": "TODO",
		"spr_path": "TODO",
		"description": "TODO",
		"distance": "TODO",
		"destinations": [
			"00b",
		]
	},
"""

# List of all the choices and their effects that can be at a location
var choices: Array = [
	{
		"title": "Upgrade Ship Armor",
		"description": "Take a trip to the Outfitters to have them install some additional armor plating on your ship.",
		"result": "The Outfitters install the additional plating without any issues. Your ship looks ready for anything, and your crew feel a bit safer.",
		"effect_ship": 15,
		"effect_crew": 5,
		"effect_cash": -15,
		"other_effects": {
			"max_hull": 25
		}
	},
	{
		"title": "R&R",
		"description": "Grant some R&R time for the crew which increases morale, however it also means their duties are neglected.",
		"result": "The crew cheer at your announcement and head to the nearest bar. They return hours later, bleary-eyed and red-faced, and attempting to sing songs they heard from a live DJ. They are terrible singers.",
		"effect_ship": -7,
		"effect_crew": 20,
		"effect_cash": -3,
	},
	{
		"title": "Rigged Gambling",
		"description": "A vice of both the obscenely wealthy and the destitute poor, there is no shortage of various games and sports in which people may place bets... You overheard from a credible source that it's rigged, and who to bet on...",
		"result": "Your source of the tip remains as credible as ever! Part of you wishes you would've bet more, but if you had lost you would have lost everything, including your ship. The crew shake their heads at you, and you suddenly feel hypocritical as you had banned them from gambling... At least you can pay them now.",
		"effect_ship": 0,
		"effect_crew": -5,
		"effect_cash": 20,
	},
	{
		"title": "Quick Gigs",
		"description": "You keep your crew around for a reason. They possess diverse skillsets, they're talented, and they're worth every credit. You can contract them out temporarily for quick odd jobs to earn some income in a pinch.",
		"result": "As the assigned crew members report back in, your credit balance has noticably improved... however you notice one of your crew is still missing. Just as you're about to ask where they are, you receive a comm-link explaining that they were made an offer they can't refuse, and had resigned. Damn poachers...",
		"effect_ship": 0,
		"effect_crew": -3,
		"effect_cash": 15,
	},
	{
		"title": "More Firepower",
		"description": "The best defense is a good offense! You're in dangerous space, and for the right price these Outfitters are offering to add a Heavy Cannon to your armaments. The downside is it will take up some space in the interior of your ship to house the additional power cells... not to mention the cost.",
		"result": "Unfortunately you had to commandeer one of the crew's quarters to house the additional power cells, but the weapon is mounted and integrated into your weapon array. You try to exercise caution, but you can't deny that part of you wishes you could be attacked soon to test it on some poor pirate...",
		"effect_ship": 20,
		"effect_crew": -5,
		"effect_cash": -10,
		"other_effects": {
			"add_weapon": "heavy_cannon"
		}
	},
	{
		"title": "Massage Chairs",
		"description": "Install Massage Chairs in the crew quarters. According to the advertisement, this is supposed to provide more quality off time, boost morale, and make the crew more effective.",
		"result": "The crew is elated as they install their new chairs, however they were bigger than you were led to believe, and you've had to shift some things around to make it work, which throws off the normal routines a bit.",
		"effect_ship": -5,
		"effect_crew": 20,
		"effect_cash": -10,
	},
	{
		"title": "Hologame Console",
		"description": "You overhear some of the crew talking about a holovid they received from back home, apparently their younger siblings are raving about a new hologame that just came out called 'Stellar Deception'... Maybe it might provide the crew some much-needed fun on their downtime.",
		"result": "The console cost less than you expected, and it's been a big hit with the crew... such a big hit in fact that you've noticed some of the crew slacking in their duties and stealing away to the crew bay to get some game time in...",
		"effect_ship": -5,
		"effect_crew": 20,
		"effect_cash": -10,
	},
	{
		"title": "'Free-sixty'",
		"description": "An Outfitter with an accent gets your attention on your way by: 'Oi bruv, Wot you fink about dis here Light Cannon? Its got a free-sixty degree field of view, and its cheap, wotcha say bruv? Its chewsday innit?' A turret weapon certainly has its uses, and price looks right...",
		"result": "The Outfitter installs it on your ship and integrates it with your weapon array. 'Whereva you point dis baby, she'll blow right frough anyfin in her way, just you watch.' You're not confident in his handiwork, but it does respond to your targeting apparatus, and it did test fire.",
		"effect_ship": 15,
		"effect_crew": 0,
		"effect_cash": -12,
		"other_effects": {
			"add_weapon": "light_cannon"
		}
	},
	{
		"title": "Thruster Upgrades",
		"description": "While browsing what upgrades are available for your ship, you see an advertisement for an upgraded Thruster that would allow you accelerate faster. More speed is never a bad thing, and the price seems reasonable.",
		"result": "The Outfitters install the upgrades without any issues, but one of your senior crew alert you to the fact that your ship doesn't have a compatible cooling system, so crew will have to be assigned to manually cool when it overheats...",
		"effect_ship": 20,
		"effect_crew": -3,
		"effect_cash": -10,
		"other_effects": {
			"thrust_power": 50
		}
	},
	{
		"title": "'Bay-sale'",
		"description": "You've noticed your ship has become extremely cluttered with unused gear, perhaps you can sell some equipment and earn some credits. Back home this would've been called a 'Garage Sale', but that doesn't quite fit here, so 'Bay-sale' it is.",
		"result": "You instruct the crew to gather all the unused stuff at the mouth of the cargo bay, and throughout the day the pile slowly dwindled and credits trickled in. Hopefully you didn't need that stuff...",
		"effect_ship": -10,
		"effect_crew": 0,
		"effect_cash": 15,
	},
	{
		"title": "Ship Maintenance",
		"description": "It's about that time, the crew won't like it as it will impact their downtime, but the ship comes first. Order the crew to perform the time-consuming maintenance tasks that they've been avoiding.",
		"result": "The crew grumble when you give your orders, but they comply. In an attempt to mitigate their ire, you throw on some work clothes and join them. Once it is done, you all have just enough time to sleep before the next task awaits.",
		"effect_ship": 20,
		"effect_crew": -12,
		"effect_cash": -3,
	},
	{
		"title": "On-ship Chef",
		"description": "While looking through the classifieds for opportunities, you see the advertisement for an on-board Chef... Your stomach gurgles as you imagine the delicacies, and then knots uncomfortably when you remember what tonight's meal will be... Maybe it's time to change it up.",
		"result": "The first meal was amazing, many of the crew were leaned back and loosening their belts to make more room. Unfortunately having to have all these ingredients on hand costs money and space within the ship, not to mention the Chef's pay... but you still feel you made the right choice.",
		"effect_ship": -5,
		"effect_crew": 30,
		"effect_cash": -20,
	},
	{
		"title": "Lay-offs",
		"description": "If you're in a bad spot financially where you're bleeding funds, you can always start cutting costs. Guess what your biggest expense is? The crew. There's always slackers to be found in any job, but don't be surprised if your ship falls apart... you hired them for a reason in the first place.",
		"result": "You review the details of the various jobs the crew performs, and you find what you think are the weakest performers and terminate their employment effective immediately. Naturally this has the remaining crew on edge, and you feel their resentment when you're around them. You'd best not make this a habit, or you're likely to face a mutiny.",
		"effect_ship": -7,
		"effect_crew": -20,
		"effect_cash": 25,
	},
	{
		"title": "Hire More Crew",
		"description": "You've got a great crew, but you've noticed more mistakes keep happening during routine procedures. When you look into it you find that you've got a few in the crew that are doing multiple jobs. Might be time to bring on some more hands to join your crew.",
		"result": "You wander over to the job boards, many people are trying to get your attention but you're focused on certain skillsets. After spending an hour scanning all the holoplates, you find some likely candidates and conduct impromptu interviews. You found a few who you think will mesh with the crew and hire them, and they eagerly accompany you back to your ship.",
		"effect_ship": 3,
		"effect_crew": 15,
		"effect_cash": -10,
	},
	{
		"title": "Ferry Passengers",
		"description": "Cargo isn't the only thing you can transport. There's always an abundance of people willing to pay to travel to other worlds. Maybe you can find some passengers that want a lift over to your next destination.",
		"result": "You find a few passengers that are wanting to go the same way you are. You had to vacate some of the crew's quarters to make their stay more comfortable, but it's only temporary, and the pay is good.",
		"effect_ship": -3,
		"effect_crew": -8,
		"effect_cash": 15,
	},
	{
		"title": "Black Market Upgrades",
		"description": "You've heard rumors of a black market dealer who offers experimental ship modifications not available through legitimate channels. Their tech could give you an edge, but comes with risks.",
		"result": "After following a series of cryptic directions, you meet the dealer in a shadowy maintenance bay. You briefly haggle with them, and they discreetly install an experimental reactive armor that should provide superior protection, though they warn it might be 'a little unstable. One of your senior crew looks concerned but admits the tech is impressive.",
		"effect_ship": 20,
		"effect_crew": 0,
		"effect_cash": -15,
		"other_effects": {
			"max_hull": 60
		}
	},
	{
		"title": "Crew Medical Checkups",
		"description": "The port has a reputable medical facility where your crew can receive comprehensive health screenings and treatments for any developing conditions.",
		"result": "Your crew undergoes thorough medical examinations. Several minor health issues are caught early and treated, and everyone receives updated vaccinations against common space-borne illnesses. The crew returns to the ship feeling relieved. Relieved that they're done with all the shots and exams, and relieved that they're more protected.",
		"effect_ship": 0,
		"effect_crew": 20,
		"effect_cash": -12,
	},
	{
		"title": "Emergency Drills",
		"description": "You've noticed your crew sometimes panics and freezes up in intense situations. Now's the time to run through some drills so they're more prepared in emergency situations. You'll have to pay them overtime to avoid a riot though...",
		"result": "You spend the day running through emergency procedures, and conducting scenarios and after-action-reviews. Everyone feels more prepared for whatever the future may bring, and the crew is itching to spend the extra stipend you had to pay them...",
		"effect_ship": 5,
		"effect_crew": 15,
		"effect_cash": -15,
	},
	{
		"title": "Navigation Database Update",
		"description": "It's been awhile since you've been this far, and the nearby space is unfamiliar to you. Spending a few credits to gain access to navigational updates could greatly improve your ship's readiness.",
		"result": "You transmit the funds and unlock the update. You spend hours waiting for it to complete, and you don't dare abort it. You've heard tales of ships being lost in space due to a failed update... The update eventually completes, and you run a few diagnostics to make sure everything works. You should be fine... you hope.",
		"effect_ship": 10,
		"effect_crew": 0,
		"effect_cash": -6,
	},
	{
		"title": "Environmental Systems Refresh",
		"description": "One of the most important things a ship has is their 'enviro' systems. Breathing is rather important, you'd rather keep breathing. It's probably a good idea to hire some experts to service your ship before it's too late.",
		"result": "Your crew assists the contractors disassembling, cleaning, and repairing the enviro, and in a few hours it's all back together and working again. You swear the air feels cleaner, gravity feels more solid than it used to, and the temperature a little cooler than before.",
		"effect_ship": 15,
		"effect_crew": 6,
		"effect_cash": -12,
	},
	{
		"title": "Salvage Auction",
		"description": "The port is holding an auction for precious in-demand parts acquired from abandoned vessels and stations in the sector. With a winning bid, you could obtain rare and expensive parts for a fraction of what they would normally cost.",
		"result": "After a few hours of fast-paced bidding, you and your crew return to your ship with several upgrades and spare parts. There was more you wanted, but apparently others wanted them more, and you're content with the haul. ",
		"effect_ship": 15,
		"effect_crew": 0,
		"effect_cash": -8,
	},
	{
		"title": "Trade Goods",
		"description": "No matter where you travel, evert port has one thing in common... trade! Buy low, sell high, it's been the driver of growth since before humans invented currency.",
		"result": "You spend a few hours in the markets, and you were able to turn a few spare supplies into a profit. Nothing glorious or exciting, but it pays the bills.",
		"effect_ship": -4,
		"effect_crew": 0,
		"effect_cash": 10,
	},
]

# Template to use for additional choices
"""
	{
		"title": "TODO",
		"description": "TODO",
		"result": "TODO",
		"effect_ship": 0,
		"effect_crew": 0,
		"effect_cash": 0,
		"other_effects": {
			"max_hull": 0
		}
	},
"""

# I think to avoid repition, let's duplicate the choices list, and remove them as we use them.
var choices_remaining: Array = choices.duplicate(true)

# Remove a choice from the list
func remove_choice_by_title(choice_title: String) -> void:
	# I changed my mind, don't remove anything!
	# I don't have time to create all the choices needed to avoid crashes lol
	return
	
	## Iterate through our remaining choices and find the index of the one that has our title
	#var target_index: int = -1 # Initialize to an out-of-bounds value, so we know if we actually found one
	#for i in choices_remaining.size():
		## Does this have our specified title?
		#if choices_remaining[i].title == choice_title:
			## We found it, mark it for deletion and break out of loop
			#target_index = i
			#break
	#
	## Did we find an index to delete?
	#if target_index > -1:
		## We did, delete it
		#choices_remaining.remove_at(target_index)
	

# Gets a random set of choices from the remaining choices, with an even spread of effects.
func get_random_choices(how_many: int) -> Array:
	# Prepare output
	var output: Array = []
	
	# First, let's determine how many choices we need for each effect
	var need: int = int(how_many/3) # Example: 7/3 gives you 2.33, casting it as an int makes it just 2
	
	# Get 3 lists of choices that are remaining for each effect
	var ship_choices: Array = _get_choices_by_effect("effect_ship")
	var crew_choices: Array = _get_choices_by_effect("effect_crew")
	var cash_choices: Array = _get_choices_by_effect("effect_cash")
	
	# Next, let's go through how many we need from each type and add them to output
	for _i in need:
		# Ship
		var i: int = randi() % ship_choices.size()
		output.append(ship_choices[i])
		ship_choices.remove_at(i)
		
		# Crew
		i = randi() % crew_choices.size()
		output.append(crew_choices[i])
		crew_choices.remove_at(i)
		
		# Cash
		i = randi() % cash_choices.size()
		output.append(cash_choices[i])
		cash_choices.remove_at(i)
	
	# Now that we have our required mix of choices, let's make sure we have the specified amount
	var remaining: int = how_many - output.size()
	for _i in remaining:
		var i: int = randi() % choices_remaining.size()
		output.append(choices_remaining[i])
	
	# Return the output
	return output

# Helper function, effect should be "effect_ship", "effect_crew", or "effect_cash"
func _get_choices_by_effect(effect: String) -> Array:
	# Prepare output
	var output: Array = []
	# Iterate through each of our choices and get the ones that have the highest value of the specified effect
	for choice in choices_remaining:
		# Determine the highest effect
		var highest_value = choice.effect_ship
		var highest_effect = "effect_ship"
		if choice.effect_crew > highest_value:
			highest_value = choice.effect_crew
			highest_effect = "effect_crew"
		if choice.effect_cash > highest_value:
			highest_value = choice.effect_cash
			highest_effect = "effect_cash"
		
		# Is this effect our specified effect?
		if highest_effect == effect:
			# It is, add it to output
			output.append(choice)
	
	# Return the output
	return output

# Array of random events that can occur while travelling
var events: Array = [
	# Derelict Ship 1
	{
		"e_id": "Derelict Ship 1",
		"description": "As you're travelling to your destination, your scannners read an inert vessel nearby. There appear to be no signs of life, and there could be things you can salvage.",
		"choices": [
			{
				"description": "Attempt to search the derelict ship.",
				"result": "You send your crew in to search the ship. No signs of a struggle, and no bodies. You guess it was a mechanical failure, and someone responded to their distress beacon in time. You salvaged some extra credits, and the crew found a modular light cannon prototype that can be easily installed without the need of an Outfitter.",
				"effect_ship": 10,
				"effect_crew": 0,
				"effect_cash": 5,
				"other_effects": {
					"add_weapon": "light_cannon"
				}
			},
			{
				"description": "You've got a bad feeling, keep moving.",
				"result": "You decide play it safe and keep moving. You hear sighs of relief from your crew, you gather they were not enthusiastic about searching it.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 0,
			},
		]
	},
	# Derelict Ship 2
	{
		"e_id": "Derelict Ship 2",
		"description": "As you're travelling to your destination, your scannners read an inert vessel nearby. There appear to be no signs of life, and there could be things you can salvage.",
		"choices": [
			{
				"description": "Attempt to search the derelict ship.",
				"result": "You send your crew in to search the ship. Immediately upon breaching the door, your hear on comms: 'What the-' followed by screaming. You give quick orders to disengage, and your crew complies rapidly. You engage your thruster to full and flee. Once you're out of immediate danger, you debrief the crew. You've lost a few men, and no one could give a straight answer on what exactly was on that ship...",
				"effect_ship": 0,
				"effect_crew": -25,
				"effect_cash": 0,
			},
			{
				"description": "You've got a bad feeling, keep moving.",
				"result": "You decide play it safe and keep moving. You hear sighs of relief from your crew, you gather they were not enthusiastic about searching it.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 0,
			},
		]
	},
	# Derelict Ship 3
	{
		"e_id": "Derelict Ship 3",
		"description": "As you're travelling to your destination, your scannners read an inert vessel nearby. There appear to be no signs of life, and there could be things you can salvage.",
		"choices": [
			{
				"description": "Attempt to search the derelict ship.",
				"result": "You order your crew to conduct a search and salvage operation. You listen tensely as the crew communicate their findings in real-time. No survivors, many bodies, savaged, and nothing was left behind. You order a final sweep, and the crew finds a stash of spare parts that could be useful, however some things cannot be unseen, and it takes its' toll on the crew.",
				"effect_ship": 15,
				"effect_crew": -8,
				"effect_cash": 0,
			},
			{
				"description": "You've got a bad feeling, keep moving.",
				"result": "You decide play it safe and keep moving. You hear sighs of relief from your crew, you gather they were not enthusiastic about searching it.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 0,
			},
		]
	},
	# Derelict Ship 4
	{
		"e_id": "Derelict Ship 4",
		"description": "As you're travelling to your destination, your scannners read an inert vessel nearby. There appear to be no signs of life, and there could be things you can salvage.",
		"choices": [
			{
				"description": "Attempt to search the derelict ship.",
				"result": "You order your crew to conduct a search, and they find starving survivors! Their navigation system apparently crashed during an update, and their ship was able to do anything except sustain life support. Their captain asks you to help the survivors, and you agree. He pays you what credits he has left, and points out a few survivors that would be useful crew members, and then he returns to his ship. 'A Captain goes down with his ship, I've got nothing left. Take care of them'. You resume course with a melancholic sigh.",
				"effect_ship": 0,
				"effect_crew": 15,
				"effect_cash": 20,
			},
			{
				"description": "You've got a bad feeling, keep moving.",
				"result": "You decide play it safe and keep moving. You hear sighs of relief from your crew, you gather they were not enthusiastic about searching it.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 0,
			},
		]
	},
	# Black Hole 1
	{
		"e_id": "Black Hole 1",
		"description": "Alarm claxons sound, as you pull up the alert you see a Black Hole dead ahead!",
		"choices": [
			{
				"description": "Order all hands to brace and charge into the hole.",
				"result": "A quick glance through the instrumentation guages and you already know you're caught in it. You decide the best hope is to try to punch through. You engage full thruster and brace... and nothing seems to happen. The alarms stop, and as you once again look to your instrumentation guages, they're returning to normal levels. Your navigation seems to be weird however... you're not sure if it's pointing you in the right direction anymore, but your ship is undamaged.",
				"effect_ship": 10,
				"effect_crew": 0,
				"effect_cash": 5,
				"other_effects": {
					"teleport": ""
				}
			},
			{
				"description": "Order all hands to perform evasive action.",
				"result": "You panic, ordering crew to perform evasive action. You turn your ship and fight against the pull. You disengage safety protocols and divert all power into your thrusters. You break away from the pull but at a cost, several systems are flashing red, and the crew are scrambling to contain fires. Your ship still flies, but you'd best take it easy until you can get into port and conduct repairs.",
				"effect_ship": -15,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# Food Parasites
	{
		"e_id": "Food Parasites",
		"description": "A crewman alerts you that something is wrong with the food stores. There appears to be some sort of parasite infesting some of it.",
		"choices": [
			{
				"description": "Conduct an inventory of all stores and jettison any tainted goods.",
				"result": "You immediately rally some of the crew and begin going through everything. About 25% of your food is not fit for consumption, and you order it to be jettisoned. Some of the crew are also ill, but it does not appear to be lethal or contagious. You should have enough to get by, but you'll need to spend more than you budgeted for on restocking when you next arrive at a port.",
				"effect_ship": 0,
				"effect_crew": -15,
				"effect_cash": -10,
			},
			{
				"description": "Food Prep: Laser-fry everything to burn the parasites and re-cryo it.",
				"result": "You rapidly organize some of the crew to behind laser-frying everything, and then putting it back in cryogenesis for storage. None of the food is wasted, however some of the meals will taste off, much to the chagrin of the crew.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Electrical interference
	{
		"e_id": "Electrical Interference",
		"description": "Your navigation systems appear to be malfunctioning, as well as some other electrical systems. It's sporadic, and you get a sense there's some sort of interference at play here.",
		"choices": [
			{
				"description": "Ascertain the source of the interference.",
				"result": "You organize some crew to investigate the interference, and it turns out someone's cell phone wasn't in spaceship mode. Everyone has a good laugh at the sheepish owner of the phone, and he takes it in stride.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 0,
			},
			{
				"description": "Your engines still work, get out of here.",
				"result": "You decide whatever is interfering could be malicious, and you've no mind to hang around. You engage full thrusters and attempt to outrun whatever might be causing this. Eventually your systems return to normal, but not before you bounce off a few small asteroids that your malfunctioning instrumentation failed to warn you about.",
				"effect_ship": -15,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# Distress Beacon 1
	{
		"e_id": "Distress Beacon 1",
		"description": "A Distress Beacon alert blips on your console. You attempt to establish communications however there is no response.",
		"choices": [
			{
				"description": "Divert course toward the beacon to render aid.",
				"result": "As you pull alongside the disabled craft, your scanners indicate signs of life. The crew breach the jammed hatch and find joyous and relieved survivors. The captain thanks you for your aid, and pays you handsomely for your troubles. Your ship will be tightly packed for awhile, but you'll be able to get these people to safety.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 20,
			},
			{
				"description": "Maintain course and ignore it, it's not your problem.",
				"result": "'Sir, what if someone really needed help?' one of the crew asks you. 'What if it's a trap and then we're the ones who need help?' you respond wryly. You've got enough to worry about right now, but some of the crew aren't happy with your decision.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Distress Beacon 2
	{
		"e_id": "Distress Beacon 2",
		"description": "A Distress Beacon alert blips on your console. You attempt to establish communications however there is no response.",
		"choices": [
			{
				"description": "Divert course toward the beacon to render aid.",
				"result": "As you pull alongside the disabled craft, your scanners indicate no signs of life. Suddenly an alarm claxon sounds. You rapidly scan your console and see a hostile ship coming right for you! You order the crew to battle stations as the first salvo hits your ship.",
				"effect_ship": -10,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": {
					"pirate_attack": 1
				}
			},
			{
				"description": "Maintain course and ignore it, it's not your problem.",
				"result": "'Sir, what if someone really needed help?' one of the crew asks you. 'What if it's a trap and then we're the ones who need help?' you respond wryly. You've got enough to worry about right now, but some of the crew aren't happy with your decision.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Distress Beacon 3
	{
		"e_id": "Distress Beacon 3",
		"description": "A Distress Beacon alert blips on your console. You attempt to establish communications however there is no response.",
		"choices": [
			{
				"description": "Divert course toward the beacon to render aid.",
				"result": "As you pull alongside the disabled craft, your scanners indicate no signs of life. The crew breach the jammed hatch and find the decayed corpses of the inhabitants of the other ship. No signs of struggle, it appears they either died of starvation or life support was inoperable. You salvage some supplies and parts for your ship and move on.",
				"effect_ship": 15,
				"effect_crew": -5,
				"effect_cash": 0,
			},
			{
				"description": "Maintain course and ignore it, it's not your problem.",
				"result": "'Sir, what if someone really needed help?' one of the crew asks you. 'What if it's a trap and then we're the ones who need help?' you respond wryly. You've got enough to worry about right now, but some of the crew aren't happy with your decision.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Space Merchant 1
	{
		"e_id": "Space Merchant 1",
		"description": "A small merchant vessel hails your ship. You establish a comm link and the Merchant Captain asks if you need any supplies. He promises a lower rate as there wouldn't be any heavy tarrifs or duties charged like there would be at a port.",
		"choices": [
			{
				"description": "Accept the offer, you could always use some supplies.",
				"result": "You plot a course for the merchant vessel and soon you're pulling along side it. The Captain and an aide come over to your ship and you begin to haggle. You and your crew make a few purchases with the promised discount, and even sell a few things you have in surplus. You smile as you set your course, good things don't happen often here in this lonely void, but you've got to take them as they come.",
				"effect_ship": 10,
				"effect_crew": 10,
				"effect_cash": 5,
			},
			{
				"description": "Decline the offer, it's probably a trap anyway.",
				"result": "You thank the Captain of the merchant vessel for his offer, but decline. Some of the crew are a little disappointed but they all understand. Not everything is as it seems in the nothingness of space. Shortly after you closed comms with the merchant vessel, your sensors detect a few ships headed towards the merchant. 'Customers? Or Pirates?' you wonder as you resume your journey...",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Space Merchant 2
	{
		"e_id": "Space Merchant 2",
		"description": "A small merchant vessel hails your ship. You establish a comm link and the Merchant Captain asks if you need any supplies. He promises a lower rate as there wouldn't be any heavy tarrifs or duties charged like there would be at a port.",
		"choices": [
			{
				"description": "Accept the offer, you could always use some supplies.",
				"result": "You plot a course for the merchant vessel and soon you're pulling along side it. As you dock with them, shouts of alarm ring out from the crew! 'We've got boarders!'. You snap into action and order the crew to repel hostiles and disengage docking. Your crew suffers mild casualties and you get away, however an alarm claxon sounds as your sensors detect a pirate vessel headed right towards you. You order the crew to battle stations.",
				"effect_ship": -10,
				"effect_crew": -5,
				"effect_cash": 0,
				"other_effects": {
					"pirate_attack": 1
				}
			},
			{
				"description": "Decline the offer, it's probably a trap anyway.",
				"result": "You thank the Captain of the merchant vessel for his offer, but decline. Some of the crew are a little disappointed but they all understand. Not everything is as it seems in the nothingness of space. Shortly after you closed comms with the merchant vessel, your sensors detect a few ships headed towards the merchant. 'Customers? Or Pirates?' you wonder as you resume your journey...",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Imposter 1 lol
	{
		"e_id": "Imposter 1",
		"description": "Your sensors alert you to the fact that there is a life form detected in space... You run a scan but find no ships, and only one life form.",
		"choices": [
			{
				"description": "Investigate. How is this possible?",
				"result": "You navigate to the source and find a single solitary person in a space suit slowly spinning in space... You give orders and conduct a rescue. Once the man is aboard your ship and has undergone pressuration procedures, he emerges from the suit and grins at your wearily. 'My thanks Captain, my name's Amo, but you can call me Gus, got a spare bunk by any chance? I'm exhausted'. You arrange for some quarters for him and resume your course.\n\nLater that evening, alarms sound as a crew member is found dead. You call all-hands to mount a search and find Amo Gus guy and within minutes he is detained. After some questioning and testimony from some crew members, you determine this man was the killer, and there are 3 other crew who are still missing. You jettison him out into space without a suit this time...",
				"effect_ship": 0,
				"effect_crew": -25,
				"effect_cash": 0,
			},
			{
				"description": "Ignore it and keep moving.",
				"result": "Such impossible anomalies rarely yield a pleasant result. Whatever it is could be danger. It could be a human, it could be an alien that devours ships for all you know.",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# Imposter 2 (not really)
	{
		"e_id": "Imposter 2",
		"description": "Your sensors alert you to the fact that there is a life form detected in space... You run a scan but find no ships, and only one life form.",
		"choices": [
			{
				"description": "Investigate. How is this possible?",
				"result": "You navigate to the source and find a single solitary person in a space suit slowly spinning in space... You give orders and conduct a rescue. Once the man is aboard your ship and has undergone pressuration procedures, he emerges from the suit and grins at your wearily. You arrange for quarters and continue your course. Later you find him working alongside the crew, and some of your senior crew inform you that he's a skilled engineer, and has fixed a few things already. You decide to offer him a job, and he gladly accepts.",
				"effect_ship": 5,
				"effect_crew": 5,
				"effect_cash": 0,
			},
			{
				"description": "Ignore it and keep moving.",
				"result": "Such impossible anomalies rarely yield a pleasant result. Whatever it is could be danger. It could be a human, it could be an alien that devours ships for all you know.",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# Stowaway
	{
		"e_id": "Stowaway",
		"description": "A crew member reports an unexpected stowaway hiding among your supplies. He begs you 'Please yer honor, I was desperate to escape. I can work if that will suffice as payment.'",
		"choices": [
			{
				"description": "Detain the main to be turned into the port authorities when you next dock.",
				"result": "You order the man to be detained and kept under watch. You'll be able to make a few credits from turning him in when you arrive at your destination. His constant pleas grate on the ears of your crew however, they eventually gag him as well.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 10,
			},
			{
				"description": "Allow him to work off his passage.",
				"result": "You relent and allow him to work. Unfortunately he has no skills. After wasting some of the crew's time, they eventually just task him with cleaning, and he even fails to do that correctly.",
				"effect_ship": -2,
				"effect_crew": -5,
				"effect_cash": 0,
			},
		]
	},
	# Rogue AI Satellite
	{
		"e_id": "Rogue AI Satellite",
		"description": "Your console receives a distress signal from what appears to be an ancient automated satellite.",
		"choices": [
			{
				"description": "Investigate the signal. Why would an old satellite be in distress?",
				"result": "As you approach, it begins broadcasting increasingly erratic messages suggesting its AI has developed unusual behavior after centuries of isolation. As you prepare to leave, alarm claxons sound. Enemy ship inbound!",
				"effect_ship": -10,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": {
					"pirate_attack": 1,
				},
			},
			{
				"description": "Ignore the old satellite, it's probably just malfunctioning.",
				"result": "You're not sure why a satellite would have a distress beacon, but you'd rather not hang around to figure out why. You resume course to your destination.",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# Alien Encounter 1
	{
		"e_id": "Alien Encounter 1",
		"description": "Your sensors detect an Alien vessel nearby. It either hasn't noticed you yet or isn't bothered by your presence. Before the Peace, you're pretty sure this ship would already be running you down.",
		"choices": [
			{
				"description": "Hail the Alien Vessel, perhaps there's an opportunity here.",
				"result": "Your hails go unanswered. As you're about to resume your course, alarm claxons sound. The Alien vessel is heading right for you with weapon locks disengaged. You order your crew to battle stations and brace for the coming fight.",
				"effect_ship": -10,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": {
					"alien_attack": 1,
				},
			},
			{
				"description": "Keep moving and leave it be, you'd rather not inadvertently cause an intergalactic incident.",
				"result": "As you're about to resume your course, alarm claxons sound. Looks like it just hadn't noticed you yet because the Alien vessel is now heading right for you with weapon locks disengaged. You order your crew to battle stations and brace for the coming fight.",
				"effect_ship": -10,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": {
					"alien_attack": 1,
				},
			},
		]
	},
	# Alien Encounter 2
	{
		"e_id": "Alien Encounter 2",
		"description": "Your sensors detect an Alien vessel nearby. It either hasn't noticed you yet or isn't bothered by your presence. Before the Peace, you're pretty sure this ship would already be running you down.",
		"choices": [
			{
				"description": "Hail the Alien Vessel, perhaps there's an opportunity here.",
				"result": "You're surprised to receive a response to your hail. The (what you presume to be) Captain of the Alien ship invites you to trade and you accept. It's a tense few moments as you pull alongside the foreign craft, but before long the airlocks are set and their Captain comes aboard with a smaller species you're not familiar with. You spend the better part of an hour haggling over prices as your crew transfers cargo to and from their ship. You guess Aliens aren't so bad after all... they still weird you out though.",
				"effect_ship": 10,
				"effect_crew": 5,
				"effect_cash": 10,
			},
			{
				"description": "Keep moving and leave it be, you'd rather not inadvertently cause an intergalactic incident.",
				"result": "You resume course and leave the strange craft behind you with no issues. It strikes you as odd, many scenarios play through your head. Were they in trouble? Did they need assistance? Was it a trap? What were they doing? You set those thoughts aside and return to the present as you continue your journey.",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# Alien Encounter 3
	{
		"e_id": "Alien Encounter 3",
		"description": "Your sensors detect an Alien vessel nearby. It either hasn't noticed you yet or isn't bothered by your presence. Before the Peace, you're pretty sure this ship would already be running you down.",
		"choices": [
			{
				"description": "Hail the Alien Vessel, perhaps there's an opportunity here.",
				"result": "After a few moments your receive a semi-encrypted response to your hail. A few moments later and your console displays the decrypted (and translated) message: 'You carry evil, dispose of it or be destroyed.'. What does this mean? What are they talking about? Is it the sealed container you carry? You order the crew to battle stations. Another hail comes in and is decrypted, but not translated: U'Wyl'Git'Rekt. You're not sure what it means, but the alarm claxons translate well enough for you.",
				"effect_ship": -10,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": {
					"alien_attack": 1,
				},
			},
			{
				"description": "Keep moving and leave it be, you'd rather not inadvertently cause an intergalactic incident.",
				"result": "As your about to resume course, you receive a hail from the Alien ship. After a short delay your console displays the decrypted (and translated) message: 'You carry evil, dispose of it or be destroyed.'. What does this mean? What are they talking about? Is it the sealed container you carry? You order the crew to battle stations. Another hail comes in and is decrypted, but doesn't appear to be translated: U'Wyl'Git'Rekt. You're not sure what it means, but the alarm claxons translate well enough for you.",
				"effect_ship": -10,
				"effect_crew": 0,
				"effect_cash": 0,
				"other_effects": {
					"alien_attack": 1,
				},
			},
		]
	},
	# Alien Encounter 4
	{
		"e_id": "Alien Encounter 4",
		"description": "Your sensors detect an Alien vessel nearby. It either hasn't noticed you yet or isn't bothered by your presence. Before the Peace, you're pretty sure this ship would already be running you down.",
		"choices": [
			{
				"description": "Hail the Alien Vessel, perhaps there's an opportunity here.",
				"result": "You receive no response to your hail. As you're about to try again, the Alien ship engages their propulsion systems and move away from your position. You're fine with that, you were trying to be friendly but you'd rather they go their own way instead of attacking you.",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
			},
			{
				"description": "Keep moving and leave it be, you'd rather not inadvertently cause an intergalactic incident.",
				"result": "You resume course and leave the strange craft behind you with no issues. It strikes you as odd, many scenarios play through your head. Were they in trouble? Did they need assistance? Was it a trap? What were they doing? Your thoughts are interrupted as the Alien ship engages its' propulsion systems and moves away from your position. Odd, but at least they're operable and not in need of assistance... and also not attacking you. Win-win.",
				"effect_ship": 0,
				"effect_crew": 0,
				"effect_cash": 0,
			},
		]
	},
	# BAUWSS
	{
		"e_id": "Boss",
		"description": "You're awakened by an intercom call 'Captain to the Bridge urgently'. You quickly dress and sprint to the bridge to assume command of whatever situation has arisen. Upon arrival the crew brief you: 'Sir, there's a massive vessel that we've detected, it's keeping pace with us'. You pull up the scans to see for yourself. It is indeed an large ship... and heavily armed.",
		"choices": [
			{
				"description": "Tactical retreat. Sure it's a big ship, but yours is faster.",
				"result": "You order full speed ahead to put as much distance between you and that monstrosity as possible. As you're about leave hailing range, your console displays a message from the mysterious vessel: 'I'M DA BAUWSS'... Whatever the hell that means. Within a matter of minutes you're free of the danger, and return to your bunk to resume your rest.",
				"effect_ship": 0,
				"effect_crew": 5,
				"effect_cash": 0,
			},
			{
				"description": "Hail the big vessel to ascertain exactly what are their intentions.",
				"result": "You hail the big ship and receive an immediate and odd response. It simply reads: 'I'M DA BAUWSS'... You ask to clarify and it responds with the same message. The ship is now in range of your enhanced scanners and now you see it has a targeting lock on you with weapons primed. Alarm claxons sound as you order your crew to battle stations. You're not sure if you can fight it but you can probably outrun it... You hope there's more asteroids around for cover as well.",
				"effect_ship": 0,
				"effect_crew": -5,
				"effect_cash": 0,
				"other_effects": {
					"boss_attack": 1,
				},
			},
		]
	},
]

# Template for events:
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
				"other_effects": {
					"TODO": "",
				},
			},
		]
	},
"""

# Function to get a random event
func get_random_event() -> Dictionary:
	return events[randi() % events.size()]
