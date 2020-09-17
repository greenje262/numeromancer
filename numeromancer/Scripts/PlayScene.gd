extends CanvasLayer

var rng = RandomNumberGenerator.new()
var operand = [" + ", " - "]

var op = rng.randi_range(0,1)
var left = rng.randi_range(0, 20)
var right = rng.randi_range(0, 20)

onready var score = 0
onready var tween = $Numeromancer/Tween
onready var game_timer = $GameTimer
onready var clock = $TextureProgress

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
	$Summons.visible = false
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
	$TextureProgress.show()
	rng.randomize()
	math_problem()
	
	game_timer.start()
	game_timer.wait_time = clock.value
	yield(game_timer, "timeout")
	game_over()

func _process(delta):
	clock.value = game_timer.time_left
	
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
	$InputBox.clear()
	$Correct.hide()
	$Incorrect.hide()
	$TextureProgress.hide()
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
	summon_reveal()
	$ResetButton.show()
	$ResetButton.grab_focus()

func _on_ResetButton_pressed():
	$Problem.hide()
	$ResetButton.hide()
	$Summons.visible = false
	$Numeromancer.play("idle")
	tween.interpolate_property($Numeromancer, "position", Vector2(48, 32), Vector2(64, 32), 2)
	tween.start()
	yield(get_tree().create_timer(2), "timeout")
	game_prep()

func summon_reveal():
	$Poof.set_frame(0)
	$Poof.play("poof")
	$Poof.set_frame(0)
	yield(get_tree().create_timer(0.5), "timeout")
	summon_picker()

func summon_picker():
	if score > 0:
		$Summons.visible = true
		$Problem.text = "nice!!"
		if score < 5:
			$Summons.play("animal01")
		elif score >= 5:
			if score < 10:
				$Summons.play("animal02")
			elif score >= 10:
				if score < 15:
					$Summons.play("animal03")
				elif score >= 15:
					if score < 20:
						$Summons.play("animal04")
					elif score >= 20:
						if score < 25:
							$Summons.play("animal05")
						elif score >= 25:
							if score < 30:
								$Summons.play("animal06")
							elif score >= 30:
								if score < 35:
									$Summons.play("animal07")
								elif score >= 35:
									if score < 40:
										$Summons.play("animal08")
									elif score >= 40:
										if score < 45:
											$Summons.play("animal09")
										elif score >= 45:
											$Summons.play("animal10")
	else:
		$Problem.text = "yikes!"
