extends Control


@onready var _container: VBoxContainer = $VBoxContainer


## Replace the hint list with a new sset of strings.
## Each String becomes one Label row in the HUD.
func set_hints(hints: Array[String]) -> void:
	for child: Node in _container.get_children():
		child.queue_free()
	
	for hint: String in hints:
		var label: Label = Label.new()
		label.text = hint
		_container.add_child(label)
