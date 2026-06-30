class_name FurnitureItem
extends Resource

## Define a single placeable furniture piece
## Create .tres instances in res://resoureces/items
## Each .tres file is one furniture item the player can place

@export var id: String = ""

@export var label: String = ""

@export var texture: Texture2D = null

# Grid Size in tiles. Vector2i(1,1) = single tile
@export var size: Vector2i = Vector2i(1,1)
