mongoose = require 'mongoose'

mongoose.connect "mongodb://localhost:27017/test"
mongoose.connection.on 'error',  ->
	throw "MongoDB connection error"

mongoose.connection.on 'connected',  ->
	console.log "connected"
	exports.Question = mongoose.model "Questions", new mongoose.Schema
		text: String
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		timestamp:
			type: Date
			default: Date.now
		place: type: mongoose.Schema.ObjectId, ref: "Places"
		tags: [type: mongoose.Schema.ObjectId, ref: "Tags"]


	exports.QuestionComment = mongoose.model "QuestionsComments", new mongoose.Schema
		text: String
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		timestamp:
			type: Date
			default: Date.now
		question: type: mongoose.Schema.ObjectId, ref: "Questions"


	exports.Answer = mongoose.model "Answers", new mongoose.Schema
		text: String
		question: type: mongoose.Schema.ObjectId, ref: "Questions"
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		timestamp:
			type: Date
			default: Date.now
		votesup: [type: mongoose.Schema.ObjectId, ref: "Users"]
		votesdown: [type: mongoose.Schema.ObjectId, ref: "Users"]


	exports.AnswerFollowUp = mongoose.model "AnswersFollowUps", new mongoose.Schema
		text: String
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		timestamp:
			type: Date
			default: Date.now
		answer: type: mongoose.Schema.ObjectId, ref: "Answers"


	exports.Tag = mongoose.model "Tags", new mongoose.Schema
		name: String


	Places = new mongoose.Schema
		facebookId: 
			type: Number
		name: String
		geoLocation: []
		users: [type: mongoose.Schema.ObjectId, ref: "Users"]
		questions: [type: mongoose.Schema.ObjectId, ref: "Questions"]

	Places.index
		geoLocation: '2dsphere'

	exports.Place = mongoose.model "Places", Places

	
	exports.User = mongoose.model "Users", new mongoose.Schema
		facebookId: Number
		token: String
		name: String
		reputation:
			type: Number
			default: 0
		notificationsSet:
			type: Number
			default: 5


	exports.Notification = mongoose.model "Notifications", new mongoose.Schema
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		question: type: mongoose.Schema.ObjectId, ref: "Questions"
		timestamp:
			type: Date
			default: Date.now