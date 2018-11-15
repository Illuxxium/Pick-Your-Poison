extends Node2D

export(String, FILE, "*.json") var waves: String = "res://Waves/waveDefault.json"
var enemiesDir : String = "res://Scenes/Enemies/"
var weaponsDir : String = "res://Scenes/SpawnWeapons/"
var currentWave: int = 0
#var maxWave: int
var isEndless: bool = false
var spawnTime: int = 0
var waveTime: int = 0
var waveEnemies: int = 0
var enemiesArray: Array
var nodeEnemiesArray: Array
var weaponDropsArray: Array
var nodeWeaponDropsArray: Array

var waveDicts: Dictionary
var currentWaveDict: Dictionary

func _ready() -> void:
	resetWaves()
	var oof: Node2D = getRandomEnemy().instance()
	$Enemies.add_child(oof)
	oof.transform.origin = Vector2(200, 200)

func resetWaves():
	currentWave = 0
	isEndless = false

	var _currWave = File.new()
	_currWave.open(waves, File.READ)

	var dict = parse_json(_currWave.get_as_text())
	if(typeof(dict) == TYPE_DICTIONARY):
		currentWaveDict = dict["Waves"]["Wave0"]

	_currWave.close()
	getNextWave(true)

func getNextWave(isWaveZero: bool = false):
	if(isWaveZero):
		genCurrentWaveData()
		return
	if(currentWave >= len(waveDicts) -1):
		isEndless = true
	else:
		currentWave += 1
		genCurrentWaveData()

func genCurrentWaveData():
	spawnTime = currentWaveDict["Spawn Time"]
	waveTime = currentWaveDict["Wave Time"]
	waveEnemies = currentWaveDict["Wave Enemies"]

	enemiesArray = currentWaveDict["Enemies"]
	loadEnemies()
	weaponDropsArray = currentWaveDict["Weapon Drops"]
	loadWeapons()

func loadEnemies():
	nodeEnemiesArray = []
	for enemy in enemiesArray:
#		print(enemy)
		nodeEnemiesArray.append(load("%s%s" % [enemiesDir, enemy["Enemy Name"]]))
#	print(nodeEnemiesArray)

func loadWeapons():
	return
	nodeWeaponDropsArray = []
	for weapon in weaponDropsArray:
		print(weapon)
		nodeWeaponDropsArray.append(load("%s%s" % [weaponsDir, weapon["Weapon Name"]]))
		breakpoint

func getRandomEnemy() -> PackedScene:
	return nodeEnemiesArray[rand_range(0, len(nodeEnemiesArray))]

func getWeightedEnemy() -> PackedScene:
	var weight = 0
	var i = 0
	for x in enemiesArray:
		weight += x["Weight"]
	var target = rand_range(0, weight)
	for x in enemiesArray:
		weight -= x["Weight"]
		if(weight <= target):
			return(nodeEnemiesArray[i])
		i += 1
	return(nodeEnemiesArray[0])