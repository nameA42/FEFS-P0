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
	combat_state = CombatState.EXHAUSTED
	state_changed.emit()
