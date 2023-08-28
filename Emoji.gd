extends RigidBody2D

@export var min_speed = 200.0
@export var max_speed = 250.0




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()
	var good_guy_types = $AnimatedSprite.sprite_frames.get_animation_names()
	$AnimatedSprite.animation = good_guy_types[randi() % good_guy_types.size()]
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	if($AnimatedSprite.animation == "crazy"):
		$AnimatedSprite.rotation += 0.1
		return
	
	$AnimatedSprite.rotation += randf_range(-0.05, 0.05)
	$AnimatedSprite.rotation = clamp($AnimatedSprite.rotation, -0.25, 0.25)
	
