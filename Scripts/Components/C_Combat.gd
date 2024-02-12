class_name C_Combat extends Component

@export var faction = 1

var combat_state: CombatState = CombatState.ACTIONABLE
signal state_changed

enum CombatState
{
	ACTIONABLE = 1,
	MOVING = 2,
	ATTACKING = 3,
	EXHAUSTED = 4,
}

signal attack

func select():
	if (faction == 1):
		var menu = load("res://Objects/M_Combat.tscn").instantiate()
		root.add_child(menu)
		menu.visible = true
		print("Menu loading.")		
