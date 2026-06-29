extends Node


# Season enums
enum Season {
	SPRING,
	SUMMER,
	AUTUMN,
	WINTER
}

# Calendar Constants
const MINUTES_PER_HOUR: int = 60
const HOURS_PER_DAY: int = 24
const DAYS_PER_SEASON: int = 28

# Time Scale

## Real seconds that pass per in-game-minute
## Lower = faster clock
var seconds_per_minute: float = 1.0 # 0.1 is MAX! Breaks NPC pathing if lower that 0.1.

# Clock State
var minute: int = 0
var hour: int = 6
var day: int = 1
var current_season: int = Season.SPRING
var year: int = 1

var _timer: Timer


func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = seconds_per_minute
	_timer.autostart = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	add_to_group(SaveManager.SAVEABLE_GROUP)
	print("GameClock: Ready - ", get_datetime_string())


func _on_timer_timeout() -> void:
	_timer.wait_time = maxf(seconds_per_minute,0.1)
	_advance_minute()
	

# Cascade of the Game Clock

func _advance_minute() -> void:
	minute += 1
	GameEvents.minute_passed.emit(minute)
	if minute >= MINUTES_PER_HOUR:
		minute = 0
		_advance_hour()


func _advance_hour() -> void:
	hour += 1
	GameEvents.hour_passed.emit(hour)
	if hour >= HOURS_PER_DAY:
		hour = 0
		_advance_day()


func _advance_day() -> void:
	day += 1
	GameEvents.day_passed.emit(day)
	if day >= DAYS_PER_SEASON:
		day = 1
		_advance_season()


func _advance_season() -> void:
	current_season = (current_season + 1) % 4
	GameEvents.season_changed.emit(current_season)
	if current_season == Season.SPRING:
		_advance_year()
		
		
func _advance_year() -> void:
	year += 1
	GameEvents.year_passed.emit(year)
	
		
# Public API


## Returns the season name as a capitalized string
func get_season_name() -> String:
	return Season.keys()[current_season].capitalize()


## Return a readable datetime string
## i.e. "Spring: Day  1, Year 1 06:00"
func get_datetime_string() -> String:
	return "%s: Day %d, Year %d %02d:%02d" % \
	[get_season_name(), day, year, hour, minute]
	
	
# Saveable Contract

func get_save_id() -> String:
	return "clock"
	

func save_data() -> Dictionary:
	return {
		"minute": minute,
		"hour": hour,
		"day": day,
		"current_season": current_season,
		"year": year,
	}
	

func load_data(data: Dictionary) -> void:
	minute = data.get("minute",0)
	hour = data.get("hour",6)
	day = data.get("day",1)
	current_season = data.get("current_season",Season.SPRING)
	year = data.get("year",1)
	print("GameClock: Loaded - ",get_datetime_string())	
	
	
	
