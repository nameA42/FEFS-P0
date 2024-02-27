class_name C_AI_Chaser extends Component

func Act():
	var stats = parent.get_node("C_Stats")
	var closest_ID = faction_manager.get_closest_faction_member(faction_manager.player_faction, ID_manager.location[ID])
	if(combat_display_manager.get_in_range_area(ID, stats.rang).has(ID_manager.location[closest_ID])):
		combat_manager.actor_deal_damage(ID, closest_ID)
	elif(!parent.get_node("C_Combat").moved):
		move_manager.actor_move(ID, ID_manager.location[closest_ID], stats.speed)
