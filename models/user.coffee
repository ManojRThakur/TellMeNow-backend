schema = require './schema'

exports.postUserInfo = (data, callback) ->
	console.log data
	user = new schema.User
		facebookId: data.facebookId
		token: data.token
		name: data.name
	user.save (err, use) ->
		return callback err if err?
		return callback null, use


exports.updateUserNotification = (req, callback) ->
	data = JSON.parse req
	schema.User.findOneAndUpdate {_id: data._id}, notificationsSet: data.notificationsSet, (err, use) ->
		return callback err if err?
		return callback null, use


exports.updateUserToken = (req, callback) ->
	data = JSON.parse req
	schema.User.findOneAndUpdate {_id: data._id}, token: data.token, (err, use) ->
		return callback err if err?
		return callback null, use


exports.incUserReputation = (req, callback) ->
	data = JSON.parse req
	schema.User.findOneAndUpdate {_id: data._id}, {$inc : {notificationsSet : 1}}, (err, use) ->
		return callback err if err?
		return callback null, use


exports.decUserReputation = (req, callback) ->
	data = JSON.parse req
	schema.User.findOneAndUpdate {_id: data._id}, {$dec : {notificationsSet : 1}}, (err, use) ->
		return callback err if err?
		return callback null, use