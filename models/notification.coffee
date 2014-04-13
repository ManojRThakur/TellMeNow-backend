schema = require './schema'

exports.postNotification = (data, callback) ->
	notification = new schema.Notification
		notificationId: data.id
		user: data.user
		type: data.type
		read: false
	notification.save (err, resp) ->
		return callback err if err?
		return callback null, resp


exports.getNotification = (id, callback) ->
	schema.Notification.findOne _id: id, (err, resp) ->
		return callback err if err?
		return callback null, resp


exports.getNotificationByUser = (user, callback) ->
	schema.Notification.findOne user: user, (err, resp) ->
		return callback err if err?
		return callback null, resp

exports.getNotificationsByUser = (user, callback) ->
	schema.Notification.find user: user, (err, resp) ->
		return callback err if err?
		return callback null, resp
