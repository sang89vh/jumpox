extends Node
onready var textture:Resource = load("res://assets/light/light.png")
func _on_Timer_timeout():
	queue_free()

func _on_Area2DDirectLight_body_entered(body):
	print_debug("direction light _on_Area2DDirectLight_body_entered")
	$Light2D.enabled = false
	$Light2D.texture = textture
	$Light2D2.enabled = true

func _on_Area2DDirectLight_body_exited(body):
	print_debug("direction light _on_Area2DDirectLight_body_exited")
	$Timer.start(1)
