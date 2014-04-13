schema = require './schema'

exports.postQuestion = (data, callback) ->
	question = new schema.Question
		text: data.text
		user: data.user
		place: data.place
		tags: data.tags
	question.save (err, ques) ->
		return callback err if err?
		return callback null, ques


exports.getQuestion = (id, callback) ->
	schema.Question.findOne _id: id, (err, ques) -> 
		return callback err if err?
		return callback null, ques


exports.getQuestionByIdInArray = (ids, callback) ->
	schema.Question.find {_id: {$in: ids}}, (err, ques) -> 
		return callback err if err?
		return callback null, ques


exports.getQuestionForUser = (id, callback) ->
	schema.Question.find user: id, (err, ques) -> 
		return callback err if err?
		return callback null, ques


exports.getQuestionForUserInArray = (ids, callback) ->
	schema.Question.find {user: {$in: ids}}, (err, ques) -> 
		return callback err if err?
		return callback null, ques


exports.postAnswer = (data, callback) ->
	answer = new schema.Answer
		text: data.text
		question: data.question
		user: data.user
	answer.save (err, ans) ->
		return callback err,null if err?
		return callback null, ans


exports.addToVotesDown = (id, userId, callback) ->
	schema.Answer.votesup.pull userId
	schema.Answer.findOneAndUpdate {id: id}, {$addToSet : {votesdown : userId}}, (err, ans) ->
		return callback err if err?
		return callback null, ans


exports.addToVotesUp = (id, userId, callback) ->
	schema.Answer.votesdown.pull userId
	schema.Answer.findOneAndUpdate {id: id}, {$addToSet : {votesup : userId}}, (err, ans) ->
		return callback err if err?
		return callback null, ans


exports.removeVote = (id, userId, callback) ->
	schema.Answer.votesup.pull userId ->
		schema.Answer.votesdown.pull userId, (err, ans) ->
			return callback err if err?
			return callback null, ans


exports.getAnswersByQuestionId = (id, callback) ->
	schema.Answer.find question: id, (err, ans) -> 
		return callback err if err?
		return callback null, ans


exports.getAnswersByQuestionIdInArray = (ids, callback) ->
	schema.Answer.find {question: {$in: ids}}, (err, ans) -> 
		return callback err if err?
		return callback null, ans


exports.getAnswer = (id, callback) ->
	schema.Answer.findOne _id: id, (err, ans) -> 
		return callback err if err?
		return callback null, ans


exports.getAnswerByIdInArray = (ids, callback) ->
	schema.Answer.find {_id: {$in: ids}}, (err, ans) -> 
		return callback err if err?
		return callback null, ans


exports.getAnswersByUserId = (id, callback) ->
	schema.Answer.find user: id, (err, ans) -> 
		return callback err if err?
		return callback null, ans


exports.getAnswersByUserIdInArray = (ids, callback) ->
	schema.Answer.find {user: {$in: ids}}, (err, ans) -> 
		return callback err if err?
		return callback null, ans