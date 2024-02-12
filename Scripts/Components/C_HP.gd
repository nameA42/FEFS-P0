class_name C_HP extends Component

@export var max_hp = 1
var hp = max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(hp <= 0):
		parent.delete()

func damage(dmg):
	hp -= dmg
	print(ID, " took ", dmg, " damage!")

func del():
	pass
