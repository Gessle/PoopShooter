extends GPUParticles2D

onready var time_created = Time.get_ticks_msec()

func _process(_delta):
	if Time.get_ticks_msec() - time_created > 1000:
		queue_free()
