extends CharacterBody2D

@onready var fireTimer = $FireTimer
@onready var markerContainer = $MarkerContainer
@onready var factory:BulletFactory2D = $BulletFactory2D

var allTextures:Array[Texture2D] = [
	preload("res://art/rocket1/1.png"), 
	preload("res://art/rocket1/2.png"),
	preload("res://art/rocket1/3.png"),
	preload("res://art/rocket1/4.png"),
	preload("res://art/rocket1/5.png"),
	preload("res://art/rocket1/6.png"),
	preload("res://art/rocket1/7.png"),
	preload("res://art/rocket1/8.png"),
	preload("res://art/rocket1/9.png"),
	preload("res://art/rocket1/10.png")
	]
var data:BlockBulletsData2D

var cachedMarkers:Array[Node2D]

var mouseBtnHeld=false
var canShoot=true
var speed = 200

func get_direction()->Vector2:
	var direction:Vector2=Vector2(0,0)
	
	if Input.is_action_pressed('move_up'):
		direction.y-=1
	elif Input.is_action_pressed("move_down"):
		direction.y+=1
	
	if Input.is_action_pressed('move_left'):
		direction.x-=1
	elif Input.is_action_pressed('move_right'):
		direction.x+=1
	return direction.normalized()


func _ready():
	setupData()
	
	## populate the cached markers array for easier access
	for marker:Node2D in markerContainer.get_children():
		cachedMarkers.append(marker)

func _unhandled_input(event):
	if event.is_action_pressed('left_mouse_click'):
		mouseBtnHeld = true
	if event.is_action_released("left_mouse_click"):
		mouseBtnHeld = false
		
func _physics_process(_delta):
	velocity = get_direction() * speed
	move_and_slide()
	look_at(get_global_mouse_position())
	
	# Shoot logic
	if canShoot && mouseBtnHeld:
		data.transforms = getNewMarkerTransforms() # set the new transforms
		data.block_rotation_radians=rotation
		
		factory.spawnBlockBullets2D(data)
		canShoot=false
		fireTimer.start()
	

func setupData()->void:
	data = BlockBulletsData2D.new();
	data.textures = allTextures
	var speed_data:Array[BulletSpeedData] = BulletSpeedData.generate_random_data(5, 10,1000,250,250,500,1000);
	data.all_bullet_speed_data=speed_data
	data.collision_layer = BlockBulletsData2D.calculate_bitmask([1])
	data.collision_mask = BlockBulletsData2D.calculate_bitmask([3])
	data.texture_size = Vector2(64,64)
	data.collision_shape_size=Vector2(32,32)
	data.collision_shape_offset=Vector2(5,5)
	data.max_change_texture_time=0.1
	
	
	#data.use_block_rotation_radians=true
	
	var damageData:DamageData = DamageData.new()
	damageData.armor_damage=5
	damageData.base_damage=10
	
	data.bullets_custom_data = damageData
	data.monitorable=false
	
	## Add more markers to the MarkerContainer and see how the bullets behave
	## Don't forget to match the transforms.size() with the amount of BulletSpeedData provided if you want your bullets to have individual directions
	## The official documentation is here: https://github.com/nikoladevelops/godot-blast-bullets-2d
	
func getNewMarkerTransforms()->Array[Transform2D]:
	var transf:Array[Transform2D] = [];
	for child:Node2D in cachedMarkers:
		transf.push_back(child.get_global_transform())
	return transf;
	
func _on_fire_timer_timeout():
	canShoot=true

func _on_bullet_factory_2d_area_entered(enemy_area, bullets_custom_data:Resource, bullet_global_position:Vector2):
	pass

func _on_bullet_factory_2d_body_entered(enemy_body, bullets_custom_data:Resource, bullet_global_position:Vector2):
	pass
