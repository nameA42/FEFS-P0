class_name C_OnMap extends Component

@export var Offset = Vector2i(8, 8)

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	await root.ready

	root.ID_manager.location[parent.ID] = parent.init_pos
	parent.position = root.ID_manager.location[parent.ID]*16 + Offset



func del():
	pass
