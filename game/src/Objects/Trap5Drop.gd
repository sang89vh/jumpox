extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var object = $RayCast2D.get_collider()
	if object is KinematicBody2D:
		$RigidBody2D.sleeping = false
		$RigidBody2D2.sleeping = false
		$RigidBody2D3.sleeping = false
		$RigidBody2D4.sleeping = false
		$RigidBody2D5.sleeping = false
		$RigidBody2D6.sleeping = false
		$RigidBody2D7.sleeping = false
