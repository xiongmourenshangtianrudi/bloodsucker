extends Node
class_name object_pool
var poor_size = 1
var laser_poor:Array
var laser:PackedScene
var forground:Node2D
# Called when the node enters the scene tree for the first time.


func _init_object_pool(outlaser:PackedScene,outforground:Node2D):
	self.laser = outlaser
	self.forground = outforground
	for i in poor_size:#初始化对象池子
		var item = laser.instantiate()
		
		item.set_process(false)
		item.get_child(0).enabled = false
		item.re_to_pool.connect(set_laser)
		item.hide() #添加到场景不显示
		forground.add_child(item)
		
		laser_poor.append(item)
		
		print("初始化池子")
	pass # Replace with function body.


func get_laser()->Node2D: ##对象池有对象，则直接拿，没有就重新实例化
	if laser_poor.size()>0:
		var laser_item = laser_poor.pop_back() as Node2D
		laser_item.show()  # 激活对象的显示
		#laser_item.set_process(true)  # 激活对象的处理
		laser_item.get_child(0).enabled = true
		
		return laser_item
	else:
		var laser_item = laser.instantiate()
		forground.add_child(laser_item)
		laser_item.re_to_pool.connect(set_laser)
		return laser_item


func set_laser(reLaser)->void:
	
	print("回池子的对象",reLaser)
	if laser_poor.size()<poor_size:
		reLaser.hide()  # 隐藏对象
		reLaser.set_process(false)  # 激活对象的处理
		reLaser.get_child(0).enabled = false
		laser_poor.append(reLaser)
		#print(reLaser,"回收完成")
	else:
		print("销毁对象")
		reLaser.queue_free()
	

		
