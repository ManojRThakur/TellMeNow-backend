schema = require './schema'

exports.postTag = (data, callback) ->
	tag = new schema.Tag
		name: data.name
	tag.save (err, tg) ->
		return callback err if err?
		return callback null, tg


exports.getTag = (data, callback) ->
	schema.Tag.findOne _id: data._id, (err, tg) ->
		return callback err if err?
		return callback null, tg


exports.getTagByName = (data, callback) ->
	schema.Tag.findOne name: data.name, (err, tg) ->
		return callback err if err?
		return callback null, tg