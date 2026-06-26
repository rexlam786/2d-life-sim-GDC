# Suppress UNUSED_SIGNAL warning - this is an event bus, signals emitted and listened to from other scripts.
@warning_ignore_start("unused_signal")
extends Node


## Core Foundation 1 Signals

## Fires once on game boot, after all autoload are ready.
signal game_started()

## Fires after a successful save complete
signal game_saved(slot: int)

## Fires after a successful load complete
signal game_loaded(slot: int)


## GameClock Signals

signal minute_passed(minute: int)
signal hour_passed(hour: int)
signal day_passed(day: int)
signal season_changed(season: int)
signal year_passed(year: int)


## World Customization Foundation 2

signal item_placed(item_id: String, grid_pos: Vector2i)
signal item_removed(item_id: String, grid_pos: Vector2i)
signal item_moved(item_id: String, from: Vector2i, to: Vector2i)
signal floor_painted(grid_pos: Vector2i, floor_id: String)


## Debug Signal

signal debug_ping(message: String)


## Register Foundations

## Tracks which foundations are active in the current project.
var active_foundations: Dictionary = {
	"core": true, #Always true - core is required!
}


func _ready() -> void:
	print("GameEvents: Autoload Ready.")
	debug_ping.connect(_on_debug_ping)
	# call_deffered pushes this to the end of the frame AFTER the rest of the tree has had a chance to _ready first!
	call_deferred("_emit_game_started")
	


## Register foundation as active
func register_foundation(foundation_name: String) -> void:
	active_foundations[foundation_name] = true
	print("GameEvents: registered foundation '", foundation_name, "'")
	

func is_foundation_active(foundation_name: String) -> bool:
	return active_foundations.get(foundation_name, false)
	
	
func _on_debug_ping(message: String) -> void:
	print("DEBUG PING: ", message)


func _emit_game_started() -> void:
	print("GameEvents: emitting game_started.")
	game_started.emit()
