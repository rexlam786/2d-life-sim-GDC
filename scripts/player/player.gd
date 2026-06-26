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
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		GameEvents.debug_ping.emit("Hello from Player")
