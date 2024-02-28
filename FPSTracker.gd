extends CanvasLayer

@onready var currentFPSLabel = $BoxContainer/CurrentFPS
@onready var lowFPSLabel = $BoxContainer/LowFPS
@onready var trackFPSBtn = $BoxContainer/TrackFPSBtn

var savePath:String = OS.get_user_data_dir() + "/test.res";
var isTracking = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var lowestFps:int = 5000
func _process(_delta):
	if isTracking:
		var currentFps:int = (int)(Engine.get_frames_per_second())
		if currentFps < lowestFps:
			lowestFps = currentFps
			lowFPSLabel.text = "Lowest: " + str(lowestFps)
		currentFPSLabel.text = "FPS: " + str(currentFps)

func _on_track_fps_button_pressed():
	isTracking = !isTracking
	lowestFps=100000000

func test(arr:Array):
	for i in arr:
		print(i)

func save():
	var factory:BulletFactory2D = get_parent().get_node("Player").get_node("BulletFactory2D") as BulletFactory2D
	
	var factoryData:SaveDataBulletFactory2D = factory.save(); # should return the factory's data
	
	ResourceSaver.save(factoryData,savePath)
	

func _on_save_btn_pressed():
	save()

func _on_load_btn_pressed():
	var factory:BulletFactory2D = get_parent().get_node("Player").get_node("BulletFactory2D") as BulletFactory2D
	
	var factoryData:SaveDataBulletFactory2D = ResourceLoader.load(savePath)
	
	factory.call_deferred("clear_all_bullets")
	factory.call_deferred("load", factoryData)

func _on_fire_btn_button_down():
	get_parent().get_node('Player').mouseBtnHeld = true

func _on_fire_btn_button_up():
	get_parent().get_node('Player').mouseBtnHeld = false
