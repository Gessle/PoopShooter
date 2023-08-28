extends Node



@export var emoji_scene : PackedScene
@export var toilet_scene : PackedScene
@export var explosion : PackedScene 
@export var time_decrease_factor : float = 0.98
var points = 0
signal flush_toilet
var time_start = 0

var daily_best_score = 0
var daily_best_time = 0
var lives = 3
var paused = true


var RANDOM_SHAKE_STRENGTH: float = 30.0
var SHAKE_DECAY_RATE: float = 5.0
var shake_strength: float = 0.0
var rand = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	time_start = Time.get_unix_time_from_system()
	self.flush_toilet.connect(_on_flush_toilet)


func _process(delta):
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
	$Camera.offset = get_random_offset()

func  get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)

func _on_flush_toilet(position, rotation):
	var particle = explosion.instantiate()
	print(position)
	particle.position = position
	particle.rotation = rotation
	particle.emitting = true
	print(particle)
	add_child(particle)
	$ToiletFlush.play()


func _on_timer_timeout():
	if paused:
		return
	var spawn_location = $Path/SpawnLocation
	spawn_location.progress_ratio = randf()
	
	var emoji = emoji_scene.instantiate()
	emoji.position = spawn_location.position
	var velocity = Vector2(randf_range(emoji.min_speed, emoji.max_speed), 0)
	var v2 = Vector2(emoji.position.x, emoji.position.y)
	var angle = v2.angle_to_point($Home.position)
	
	emoji.linear_velocity = velocity.rotated(angle)
	
	add_child(emoji)

func _input(event):
	if paused:
		return
	if Input.is_action_just_pressed("click"):
		#print(event.position)
		var toilet = toilet_scene.instantiate()
		toilet.position = $Home.position
		var velocity = Vector2(200,0)
		var angle = $Home.position.angle_to_point(event.position)
		#print(angle)
		toilet.linear_velocity = velocity.rotated(angle)
		add_child(toilet)

func hit():
	$FartSound.play()
	shake_strength = RANDOM_SHAKE_STRENGTH
	lives -= 1
	$HBoxContainer/Life3.modulate = "a95200"
	if lives == 1:
		$HBoxContainer/Life2.modulate = "a95200"
	if lives == 0:
		$HBoxContainer/Life1.modulate = "a95200"
		var emojies = get_tree().get_nodes_in_group("emoji")
		for i in emojies:
			i.queue_free()
		var toilets = get_tree().get_nodes_in_group("toilet")
		for i in toilets:
			i.queue_free()
		var time_now = Time.get_unix_time_from_system()
		var time_elapsed = time_now - time_start
		if (points > daily_best_score):
			daily_best_score = points
			$PointsBest.text = "(" + str(daily_best_score) + ")"
		if (time_elapsed > daily_best_time):
			daily_best_time = time_elapsed
			$GameTimeBest.text = "(" + str(snapped(daily_best_time, 0.1)) + ")"
		paused = true
		$Menu.visible = true



func restart():
	paused = false
	$Points.text = "0"
	points = 0
	time_start = Time.get_unix_time_from_system()
	$Timer.wait_time = 1
	lives = 3
	$HBoxContainer/Life1.modulate = "ffffff"
	$HBoxContainer/Life2.modulate = "ffffff"
	$HBoxContainer/Life3.modulate = "ffffff"

func score():
	points += 1
	$Points.text = str(points)
	$Timer.wait_time *= time_decrease_factor
	$BlobSound.play()


func _on_game_timer_timeout():
	if paused:
		return
	var time_now = Time.get_unix_time_from_system()
	var time_elapsed = time_now - time_start
	#$GameTime.text = str(snapped(time_elapsed, 0.1))
	$GameTime.text = "%3.1f" % time_elapsed
