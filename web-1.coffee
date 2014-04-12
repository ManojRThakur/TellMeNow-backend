#configure apis
app = require('express')()
server = require('http').createServer(app)
io = require('socket.io').listen(server)
handler = require('./handlers/configure')

io.set('log level', 1); 

server.listen(3000)

handler.configure io, (err) -> 
	if err 
		console.error err
	else	
		console.log "App configured"
