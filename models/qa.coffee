schema = require './schema'

exports.postQuestion = (req, callback) ->
	data = JSON.parse req
	question = new schema.Question
		text: data.text
		user: data.user
		place: data.place
		tags: data.tags
	question.save (err, ques) ->
		return callback err if err?
		return callback null, ques


exports.postComment = (req, callback) ->
	data = JSON.parse req
	schema.Question.findOneAndUpdate {_id: data._id}, {$push: {"comments": {text: data.comments.text, user: data.comments.user}}}, (err, ques) ->
		return callback err if err?
		return callback null, ques


exports.getQuestion = (req, callback) ->
	data = JSON.parse req
	schema.Question.findOne _id: data._id, (err, ques) -> 
		return callback err if err?
		return callback null, ques


exports.postAnswer = (req, callback) ->
	data = JSON.parse req
	answer = new schema.Answer
		text: data.text
		question: data.question
		user: data.user
	answer.save (err, ans) ->
		return callback err,null if err?
		return callback null, ans


exports.postFollowUp = (req, callback) ->
	data = JSON.parse req
	schema.Answer.findOneAndUpdate {_id: data._id}, {$push: {"followUps": {text: data.comments.text, user: data.comments.user}}}, (err, ans) ->
		return callback err if err?
		return callback null, ans


exports.incAnswerVotes = (req, callback) ->
	data = JSON.parse req
	schema.Answer.findOneAndUpdate {_id: data._id}, {$inc : {votes : 1}}, (err, ans) ->
		return callback err if err?
		return callback null, ans


exports.decAnswerVotes = (req, callback) ->
	data = JSON.parse req
	schema.Answer.findOneAndUpdate {_id: data._id}, {$dec : {votes : 1}}, (err, ans) ->
		return callback err if err?
		return callback null, ans


exports.getAnswer = (req, callback) ->
	data = JSON.parse req
	schema.Answer.findOne _id: data._id, (err, ans) -> 
		return callback err if err?
		return callback null, ans