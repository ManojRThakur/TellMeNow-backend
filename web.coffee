#configure apis

app = require('express').createServer()
io = require('socket.io').listen(app)
handler = require('handlers/configure')

app.listen(3000)

handler.configure io, (err) -> 
	if err 
		console.error err
	else	
		console.log "App configured"

	