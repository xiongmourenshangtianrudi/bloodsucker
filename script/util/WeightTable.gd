class_name WeightedTable

var items:Array[Dictionary] = []
@export var currentWeight:int = 0
var weight_sum = 0

func add_item(item,Weight:int):
	items.append({"item":item,"Weight":Weight})
	weight_sum +=Weight

func pick_item():
	var chosen_weight = randi_range(currentWeight,weight_sum)
	var iteration_sum =0
	for item in items:
		iteration_sum+=item["Weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]


func update_minWeight(during:float):##更新最小的权重 小于1
	currentWeight = weight_sum*during
