schema = require './schema'

exports.postNotification = (data, callback) ->
	notification = new schema.Notification
		user: data.user
		question: data.question
	notification.save (err, not) ->
		return callback err if err?
		return callback null, not


exports.getNotification = (data, callback) ->
	schema.Notification.findOne _id: data._id, (err, not) ->
		return callback err if err?
		return callback null, not


exports.getNotificationByUser = (data, callback) ->
	schema.Notification.findOne user: data.user, (err, not) ->
		return callback err if err?
		return callback null, not


exports.getNotificationByQuestion = (data, callback) ->
	schema.Notification.findOne question: question.user, (err, not) ->
		return callback err if err?
		return callback null, not