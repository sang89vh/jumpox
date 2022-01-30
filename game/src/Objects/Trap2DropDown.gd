extends Area2D

func _process(delta):
	print_debug("Trap2DropDown process")
	var object = $RayCast2D.get_collider()
	if object is KinematicBody2D:
		print_debug("Trap2DropDown entered")
		$Tween.interpolate_property(self ,"position", self.position, Vector2(self.position.x , self.position.y + 700), 0.8, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		$Tween.start()
		return
	
	var object2 = $RayCast2D2.get_collider()
	if object2 is KinematicBody2D:
		print_debug("Trap2DropDown exited")
		$AnimationPlayer.play("destroy")
