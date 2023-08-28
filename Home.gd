extends Area2D



func _on_body_entered(body):
	if not (body.is_in_group("emoji")):
		return
	if(body.get_node("AnimatedSprite").animation == "poop"):
		get_node("/root/Main").hit()
	else:
		get_node("/root/Main").score()
		
	
	body.queue_free()

