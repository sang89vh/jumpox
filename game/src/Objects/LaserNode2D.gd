extends Node2D

func _on_LaserRayCast2D_laser_fire():
	print_debug("_on_LaserRayCast2D_laser_fire")
	$AnimationPlayer.play("Charging")
