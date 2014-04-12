schema = require './schema'

exports.postUserInfo = (data, callback) ->
	user = new schema.User
		facebookId: data.facebookId
		token: data.token
		name: data.name
	user.save (err, use) ->
		return callback err if err?
		return callback null, use

exports.postUserInfoByFacebookId = (facebookId, data, callback) ->
	facebookId = parseInt(facebookId)
	schema.User.findOneAndUpdate {facebookId: facebookId}, data, (err, use) ->
		return callback err if err?
		return callback null, use


exports.updateUserNotification = (data, callback) ->
	schema.User.findOneAndUpdate {_id: data._id}, notificationsSet: data.notificationsSet, (err, use) ->
		return callback err if err?
		return callback null, use


exports.updateUserToken = (data, callback) ->
	schema.User.findOneAndUpdate {_id: data._id}, token: data.token, (err, use) ->
		return callback err if err?
		return callback null, use


exports.incUserReputation = (data, callback) ->
	schema.User.findOneAndUpdate {_id: data._id}, {$inc : {notificationsSet : 1}}, (err, use) ->
		return callback err if err?
		return callback null, use


exports.decUserReputation = (data, callback) ->
	schema.User.findOneAndUpdate {_id: data._id}, {$dec : {notificationsSet : 1}}, (err, use) ->
		return callback err if err?
		return callback null, use


exports.getUser = (data, callback) ->
	schema.User.findOne _id: data._id, (err, use) ->
		return callback err if err?
		return callback null, use

exports.find = (id, callback) ->
	schema.User.findOne _id: id, (err, use) ->
		return callback err if err?
		return callback null, use.toJSON()

exports.getUserByFacebookId = (data, callback) ->
	schema.User.findOne facebookId: data.facebookId, (err, use) ->
		return callback err if err?
		return callback null, use