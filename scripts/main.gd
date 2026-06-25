extends Node2D

## Root of the 2D Life Sim
## Foundational scenes will be instanced under World in future episodes.

var message: String = "Main: Scene Ready."

func _ready() -> void:
	print(message)
