connectionMapping = {}

exports.addMapping = (userId, socket) ->
	connectionMapping[userId] = socket
	console.log connectionMapping[userId]

exports.getMapping = (userId, callback) ->
	return callback connectionMapping[userId]
