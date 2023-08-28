extends RigidBody2D



func _ready():
	pass

func _on_body_entered(body):
	get_parent().flush_toilet.emit(self.position, self.rotation)
	body.queue_free()
	queue_free.call_deferred()
	



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
