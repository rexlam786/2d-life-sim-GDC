extends CharacterBody2D


## Exports

@export var walk_speed: float = 90.0 # Pixels per second

# Layer References

@onready var body_layer: Sprite2D = $BodyLayer
@onready var legs_layer: Sprite2D = $LegsLayer
@onready var feet_layer: Sprite2D = $FeetLayer
@onready var torso_layer: Sprite2D = $TorsoLayer
@onready var hair_layer: Sprite2D = $HairLayer


func _ready() -> void:
	_apply_appearance()
	GameEvents.game_started.connect(_on_game_started)
	add_to_group(SaveManager.SAVEABLE_GROUP)
	
func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_dir * walk_speed	
	move_and_slide()
	

## Assigns the default AtlasTexture to each sprite layer.
## Swap any texture here or at runtime for equipment changes
func _apply_appearance() -> void:
	body_layer.texture = preload("res://resources/characters/player/body_default.tres")
	legs_layer.texture = preload("res://resources/characters/player/legs_default.tres")
	feet_layer.texture = preload("res://resources/characters/player/feet_default.tres")
	torso_layer.texture= preload("res://resources/characters/player/torso_default.tres")
	hair_layer.texture = preload("res://resources/characters/player/hair_default.tres")
	




func _on_game_started() -> void:
	print("Player: head game_started - I am alive and ready!")
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		GameEvents.debug_ping.emit("Hello from Player")


# Saveable Contract

## Unique save ID. This must be stable across sessions.
func get_save_id() -> String:
	return "player"


func save_data() -> Dictionary:
	return {
		"position_x": position.x, 
		"position_y": position.y,
		"appearance": {
			"body": body_layer.texture.resource_path,
			"legs": legs_layer.texture.resource_path,
			"feet": feet_layer.texture.resource_path,
			"torso": torso_layer.texture.resource_path,
			"hair": hair_layer.texture.resource_path,
		},	
	}
	
	
## Restore state from the dictionary producted by save_data()
func load_data(data: Dictionary) -> void:
	position = Vector2(
		data.get("position_x", 0.0),
		data.get("position_y", 0.0),
		)
	
	var appearance: Dictionary = data.get("appearance",{})
	if not appearance.is_empty():
		body_layer.texture = load(appearance.get("body","res://resources/characters/player/body_default.tres"))
		legs_layer.texture = load(appearance.get("legs","res://resources/characters/player/legs_default.tres"))
		feet_layer.texture = load(appearance.get("feet","res://resources/characters/player/feet_default.tres"))
		torso_layer.texture = load(appearance.get("torso","res://resources/characters/player/torso_default.tres"))
		hair_layer.texture = load(appearance.get("hair","res://resources/characters/player/hair_default.tres"))
		
	# Snap the camera instantly to the loaded position.
	$Camera2D.reset_smoothing()
		
