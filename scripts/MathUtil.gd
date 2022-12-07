class_name MathUtil

static func rand_weight(weight_arr:Array)->int:
	if not weight_arr:return -1
	if weight_arr.size() <= 0: return 0
	var arr = [0]
	var total_weight:int = 0
	for i in range(weight_arr.size()):
		var weight:int = weight_arr[i]
		total_weight += weight
		arr.append(arr[i] + weight)
	var rand = rand_range(0,total_weight)
	for i in range(arr.size()):
		if rand >= arr[i] and rand <= arr[i + 1]: return i
	return -1
