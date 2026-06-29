extends Node2D


## Root of the 2D Life Sim
## Foundational scenes will be instanced under World in future episodes.

var message: String = "Main: Scene Ready."

func _ready() -> void:
	print(message)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("quick_save"):
		SaveManager.save()
	elif Input.is_action_just_pressed("quick_load"):
		SaveManager.load_game()
		
