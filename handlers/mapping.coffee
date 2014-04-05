connectionMapping = {}

exports.addMapping = (userId, socket) ->
	connectionMapping[userId] = socket

exports.getMapping = (userId, callback) ->
	return callback connectionMapping[userId]
