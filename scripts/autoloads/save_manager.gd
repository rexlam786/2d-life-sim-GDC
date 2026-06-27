extends Node


## Registered as autoload "SaveManager". Third in the autoload list. 
## Walks the saveable group at save time, collects Dictionaries, writes JSON.
## At load time, reads JSON and distributes data back by save ID. 


# Constants
const SAVEABLE_GROUP: StringName = &"saveable"
const SAVE_VERSION: int = 1
const SAVE_DIR: String = "user://saves/"
