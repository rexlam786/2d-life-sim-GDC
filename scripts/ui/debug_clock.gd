extends Label


func _ready() -> void:
	GameEvents.minute_passed.connect(_on_minute_passed)
	_refresh()
	

func _on_minute_passed(_minute: int) -> void:
	_refresh()
	

func _refresh() -> void:
	text = GameClock.get_datetime_string()
