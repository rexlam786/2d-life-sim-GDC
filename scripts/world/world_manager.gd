extends Node2D


# States
enum PlacementState {
	INSPECTING,
	PLACING,
	PAINTING
}

var current_state: PlacementState = PlacementState.INSPECTING

# Test Items
const TEST_ITEM_ID: String = "test_item"
const TEST_ITEM_PNG: String = "res://icon_small.svg"

# Grid Data
## Maps Vector2i grid positions to item ID strings
var _occupied_cells: Dictionary = {}

# Node References
@export var floor_layer: TileMapLayer
@export var hotkey_hud: Control

@onready var _ghost: Sprite2D = $GhostSprite
@onready var _placed: Node2D = $PlacedItems

var _ghost_texture: Texture2D


func _ready() -> void:
	GameEvents.register_foundation("world")
	_ghost_texture = load(TEST_ITEM_PNG)
	_ghost.modulate.a = 0.0
	_update_hotkey_hud()
	print("WorldManager: Ready.")
	
	
func _process(_delta: float) -> void:
	if current_state == PlacementState.PLACING:
		_update_ghost()


func _update_ghost() -> void:
	var grid_pos: Vector2i = _get_mouse_grid_pos()
	_ghost.global_position = floor_layer.map_to_local(grid_pos)
	
	# Red means occupied OR no floor tile at position
	var no_floor: bool = floor_layer.get_cell_source_id(grid_pos) == -1
	if _occupied_cells.has(grid_pos) or no_floor:
		_ghost.modulate = Color(1.0,0.2,0.2,0.6)
	else: 
		_ghost.modulate = Color(0.2,1.0,0.2,0.6)
	
	
func _get_mouse_grid_pos() -> Vector2i:
	return floor_layer.local_to_map(get_global_mouse_position())


# Input

func _unhandled_input(event: InputEvent) -> void:
	# B: Furniture Catalog Toggle
	if Input.is_action_just_pressed("open_furniture_catalog"):
		if current_state != PlacementState.INSPECTING:
			_exit_current_state()
		else:
			_enter_placing_mode()
		return
		
	# F: Floor Paint Toggle
	if Input.is_action_just_pressed("toggle_paint"):
		if current_state != PlacementState.INSPECTING:
			_exit_current_state()
		else:
			_enter_painting_mode()
		return
	
	# P: Cancel only
	if Input.is_action_just_pressed("toggle_placement"):
		if current_state != PlacementState.INSPECTING:
			_exit_current_state()
		return
	
	# LMB: Place or Paint
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			if current_state == PlacementState.PLACING:
				_try_place_item()

# State Transitions

func _enter_placing_mode() -> void:
	current_state = PlacementState.PLACING
	_ghost.modulate.a = 0.6
	_update_hotkey_hud()
	

func _enter_painting_mode() -> void:
	current_state = PlacementState.PAINTING
	_update_hotkey_hud()
	# Floor paint logic to be updated later
	

## Single exit point for all active states.
## Any cleanup that must happen on state exit goes here!
func _exit_current_state() -> void:
	current_state = PlacementState.INSPECTING
	_ghost.modulate.a = 0.0
	_update_hotkey_hud()


# Placement

func _try_place_item() -> void:
	var grid_pos: Vector2i = _get_mouse_grid_pos()
	if _occupied_cells.has(grid_pos):
		return
	# Prevent placement outside painted floor tiles
	if floor_layer.get_cell_source_id(grid_pos) == -1:
		return
	_place_item_at(grid_pos)


func _place_item_at(grid_pos: Vector2i) -> void:
	var world_pos: Vector2 = floor_layer.map_to_local(grid_pos)
	
	var body: StaticBody2D = StaticBody2D.new()
	var sprite: Sprite2D = Sprite2D.new()
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	
	sprite.texture = _ghost_texture
	rect.size = _ghost_texture.get_size()
	shape.shape = rect
	
	body.add_child(sprite)
	body.add_child(shape)
	body.position = world_pos
	body.name = "Placed_%d_%d" % [grid_pos.x, grid_pos.y]
	
	_placed.add_child(body)	
	_occupied_cells[grid_pos] = TEST_ITEM_ID
	
	GameEvents.item_placed.emit(TEST_ITEM_ID, grid_pos)
	print("WorldManager: Placed '%s' at %s" % [TEST_ITEM_ID,grid_pos])

# Hitkey Hud

func _update_hotkey_hud() -> void:
	if hotkey_hud == null:
		return
	var hints: Array[String] = []
	match current_state:
		PlacementState.INSPECTING:
			hints = [
				"B: Furniture Catalog",
				"F: Floor Paint",
			]
		PlacementState.PLACING:
			hints = [
				"LMB: Place",
				"P or B: Cancel"
			]
		PlacementState.PAINTING:
			hints = [
				"LMB: Paint",
				"P or F: Cancel"
			]
	hotkey_hud.set_hints(hints)



	
	
	
	
	
