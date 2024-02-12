class_name C_Combat extends Component

@export var faction = 1

var combat_menu: Control

enum CombatState
{
	ACTIONABLE = 1,
	MOVING = 2,
	ATTACKING = 3,
	EXHAUSTED = 4,
}

var combat_state: CombatState = CombatState.ACTIONABLE

signal attacking
signal state_changed
signal moving

func select():
	if (faction == 1):
		combat_menu = load("res://Objects/M_Combat.tscn").instantiate()
		root.add_child(combat_menu)
		combat_menu.visible = true
		combat_menu.actor_owner = parent
		
		var attack_button: Button = combat_menu.add_option("Attack")
		attack_button.pressed.connect(prepare_attack)
		
		var wait_button: Button = combat_menu.add_option("Wait")
		wait_button.pressed.connect(wait)
		return true
		

func prepare_attack():
	combat_menu.queue_free()
	pass
	
func attack(target: Actor):
	print("Attacking!")
	attacking.emit(parent, target)
	
func wait():
	print("Test")
	combat_menu.queue_free()
	combat_state = CombatState.EXHAUSTED
	state_changed.emit()
	# TODO: Re enable cursor from faction/turn manager.
	
func move():
	pass
	
func prepare_move(destination: Vector2i):
	moving.emit(ID_manager.location[ID], destination)
	
