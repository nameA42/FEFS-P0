extends Node

func Cur_Move_Sound():
	$"CurSound".play()

func Walk_Sound():
	$"WalkSound".play()
	
func Walk_Sound_Stop():
	$"WalkSound".stop()

func Cur_Select_Sound():
	$"CurSelectSound".play()

func Dialogue_Proegress_Sound():
	$"DialogueProgressSound".play()
	

#Might find a way to make this into an array
func Hit_Sound():
	var rand = randi() % 2
	
	if(rand == 0):
		$"HitSound1".play()
	else:
		$"HitSound2".play()

func Phase_Change_Sound():
	$"PhaseChangeSound".play()

func Death_Remove_Sound():
	$"DeathRemoveSound".play()

func Menu_Cur_Sound():
	$"MenuCurSound".play()

func Miss_Sound():
	$"MissSound".play()
