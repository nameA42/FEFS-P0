class_name C_InteractionMenu extends Component

var Stats : Node2D = null
var interaction_mode = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	Stats = parent.get_node("C_Stats")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func selection(sel : int):
	if(sel == 0):
		combat_display_manager.combat_display_manager.display_reachable_area(ID, Stats.speed)
		interaction_mode = 0
	if(sel == 1):
		combat_display_manager.combat_display_manager.display_in_range_area(ID, Stats.rng)
		interaction_mode = 1
