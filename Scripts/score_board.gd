extends Control


@onready var kills_label: Label = $Background/HBoxContainer/Score/Kills/KillsLabel
@onready var coins_label: Label = $Background/HBoxContainer/Score/Coins/CoinsLabel
@onready var gems_label: Label = $Background/HBoxContainer/Score/Gems/GemsLabel
@onready var dorado_label: Label = $Background/HBoxContainer/Score/PuzzleDorado/DoradoLabel
@onready var duat_label: Label = $Background/HBoxContainer/Score/PuzzleDuat/DuatLabel
@onready var atlantis_label: Label = $Background/HBoxContainer/Score/PuzzleAtlantis/AtlantisLabel
@onready var total_label: Label = $Background/HBoxContainer/Score/Total/TotalLabel

func _ready() -> void:
	kills_label.text = "Enemies: " + "10 x " + str(GameManager.kill_count) + " = +" + str(10*GameManager.kill_count)
	coins_label.text = "Coins: " + "10 x " + str(GameManager.coin_count) + " = +" + str(10*GameManager.coin_count)
	gems_label.text = "Gems: " + "10 x " + str(GameManager.gem_count) + " = +" + str(10*GameManager.gem_count)
	dorado_label.text = "Puzzle Dorado: +1000" 
	duat_label.text = "Puzzle Duat: +1000" 
	atlantis_label.text = "Puzzle Atlantis: +1000" 
	total_label.text = "Total points: " + str(GameManager.score)
