extends CanvasLayer

var rng = RandomNumberGenerator.new()
var operand = [" + ", " - "]

var op = rng.randi_range(0,1)
var left = rng.randi_range(0, 20)
var right = rng.randi_range(0, 20)

onready var score = 0
onready var tween = $Numeromancer/Tween

func _ready():
	game_prep()

func game_prep():
	score = 0
	$ScoreCounter.text = str(score)
	$ScoreCounter.hide()
	$Correct.hide()
	$Incorrect.hide()
	$InputBox.hide()
	$InputBox.editable = true
	$Problem.hide()
	$ResetButton.hide()
	$Title.show()
	$PlayButton.show()
	$PlayButton.grab_focus()

func game_start():
	$Numeromancer.play("idle")
	$ScoreCounter.show()
	$Problem.show()
	$Problem.text = "READY"
	yield(get_tree().create_timer(2), "timeout")
	
	$Problem.text = "GO!!"
	yield(get_tree().create_timer(1), "timeout")
	
	$InputBox.show()
	$InputBox.grab_focus()
	rng.randomize()
	math_problem()
	
	yield(get_tree().create_timer(10), "timeout")
	game_over()

func _process(delta):
	if Input.is_action_just_pressed("answer") and $InputBox.text != "":
		evaluate()

func math_problem():
	left = rng.randi_range(0, 20)
	right = rng.randi_range(0, 20)
	
	op = rng.randi_range(0,1)
	
	$Problem.text = str(left)+operand[op]+str(right)

func evaluate():
	if $Problem.text != "":
		if op == 0:
			if left + right == int($InputBox.text):
				success()
			else:
				failure()
		elif op == 1:
			if left - right == int($InputBox.text):
				success()
			else:
				failure()
		
		$ScoreCounter.text = str(score)
		$InputBox.clear()
		math_problem()

func success():
	score += 1
	$Correct.show()
	yield(get_tree().create_timer(1), "timeout")
	$Correct.hide()

func failure():
	$Incorrect.show()
	yield(get_tree().create_timer(1), "timeout")
	$Incorrect.hide()

func _on_PlayButton_pressed():
	game_start()
	$Title.hide()
	$PlayButton.hide()

func game_over():
	$Problem.text = ""
	$InputBox.hide()
	$InputBox.editable = false
	$Correct.hide()
	$Incorrect.hide()
	summon()

func summon():
	num_summon()
	yield(get_tree().create_timer(2), "timeout")
	sum_summon()

func num_summon():
	$Numeromancer.play("casting")
	tween.interpolate_property($Numeromancer, "position", Vector2(64, 32), Vector2(48, 32), 2)
	tween.start()

func sum_summon():
	$Numeromancer.play("release")
	$Summons.play("poof")
	$Problem.text = "nice!!"
	$ResetButton.show()
	$ResetButton.grab_focus()

func _on_ResetButton_pressed():
	$Numeromancer.play("idle")
	tween.interpolate_property($Numeromancer, "position", Vector2(48, 32), Vector2(64, 32), 2)
	tween.start()
	yield(get_tree().create_timer(2), "timeout")
	game_prep()
