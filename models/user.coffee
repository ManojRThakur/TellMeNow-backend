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


exports.getUser = (id, callback) ->
	schema.User.findOne _id: id, (err, use) ->
		return callback err if err?
		return callback null, use


exports.getUserByIdInArray = (ids, callback) ->
	schema.User.find {_id: {$in: ids}}, (err, use) ->
		return callback err if err?
		return callback null, use


exports.find = (id, callback) ->
	console.log id
	schema.User.findOne _id: id, (err, use) ->
		return callback err if err?
		return callback null, use.toJSON()

exports.getUserByFacebookId = (id, callback) ->
	schema.User.findOne facebookId: id, (err, use) ->
		return callback err if err?
		return callback null, use


exports.getUserByFacebookIdInArray = (ids, callback) ->
	schema.User.find {facebookId: {$in: ids}}, (err, use) ->
		return callback err if err?
		return callback null, use