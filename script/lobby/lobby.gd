extends Node
const PORT = 7000
const MAX_CONNECTIONS =2
signal player_connected(peer_id,peer_info)
var players:Dictionary = {}
var player_info={
	"name":"Name"
}

func _create_multiplayer_lobby():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT,MAX_CONNECTIONS)
	if error :
		return error
		
	multiplayer.multiplayer_peer = peer #将对等体放入对象
	
	players[1] = player_info
	player_connected.emit(1,player_info)

#搜索主机，选择后加入主机 广播的方式！！
