schema = require './schema'

exports.postFollowUp = (data, callback) ->
	followup = new schema.AnswerFollowUp
		text: data.text
		user: data.user
		answer: data.answer
	followup.save (err, fol) ->
		return callback err if err?
		return callback null, fol


exports.getFollowUp = (id, callback) ->
	schema.AnswerFollowUp.findOne _id: id, (err, fol) ->
		return callback err if err?
		return callback null, fol


exports.getFollowUpByAnswerId = (id, callback) ->
	schema.AnswerFollowUp.find answer: id, (err, fol) ->
		return callback err if err?
		return callback null, fol


exports.getFollowUpInArray = (ids, callback) ->
	schema.AnswerFollowUp.find {_id: {$in: ids}}, (err, fol) ->
		return callback err if err?
		return callback null, fol


exports.getFollowUpByAnswerIdInArray = (ids, callback) ->
	schema.AnswerFollowUp.find {answer: {$in: ids}}, (err, fol) ->
		return callback err if err?
		return callback null, fol