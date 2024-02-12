extends Node2D

@onready var root = get_tree().root.get_child(0)

func _ready():
	for unit in root.find_child("Units").get_children():
		unit.find_child("C_Combat").attacking.connect(on_actor_attack)

func on_actor_attack(actor, target):
	var actor_stats = root.ID_manager.id_to_obj[actor].get_node_or_null("C_Stats")
	print(actor_stats)
	if(actor_stats != null):
		if(root.combat_display_manager.get_in_range_area(actor, actor_stats.rang).has(root.ID_manager.location[target])):
			var target_health = root.ID_manager.id_to_obj[target].get_node_or_null("C_HP")
			if(target_health != null):
				target_health.damage(actor_stats.str)
