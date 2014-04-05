connectionMapping = {}

exports.addMapping = (userId, socket) ->
	connectionMapping[userId] = socket

exports.getMappinf = (userId, callback) ->
	return callback connectionMapping[userId]
