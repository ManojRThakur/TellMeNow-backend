schema = require './schema'

exports.postComment = (data, callback) ->
	comment = new schema.QuestionComment
		text: data.text
		user: data.user
		question: data.question
	comment.save (err, com) ->
		return callback err if err?
		return callback null, com


exports.getComment = (id, callback) ->
	schema.QuestionComment.findOne _id: id, (err, com) ->
		return callback err if err?
		return callback null, com


exports.getCommentByQuestionId = (id, callback) ->
	schema.QuestionComment.find question: id, (err, com) ->
		return callback err if err?
		return callback null, com


exports.getCommentInArray = (ids, callback) ->
	schema.QuestionComment.find {_id: {$in: ids}}, (err, com) ->
		return callback err if err?
		return callback null, com


exports.getCommentByQuestionIdInArray = (ids, callback) ->
	schema.QuestionComment.find {question: {$in: ids}}, (err, com) ->
		return callback err if err?
		return callback null, com