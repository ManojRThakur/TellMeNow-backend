mongoose = require 'mongoose'

mongoose.connect "mongodb://localhost/test"

exports.Question = mongoose.model "Questions", new mongoose.Schema
	text: String
	user: type: mongoose.Schema.ObjectId, ref: "Users"
	timestamp:
		type: Date
		default: Date.now
	place: type: mongoose.Schema.ObjectId, ref: "Places"
	tags: [type: mongoose.Schema.ObjectId, ref: "Tags"]
	comments: [
		text: String
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		timestamp:
			type: Date
			default: Date.now
	]


exports.Answer = mongoose.model "Answers", new mongoose.Schema
	text: String
	question: type: mongoose.Schema.ObjectId, ref: "Questions"
	user: type: mongoose.Schema.ObjectId, ref: "Users"
	timestamp:
		type: Date
		default: Date.now
	votes: 
		type: Number
		default: 0
	followUps: [
		text: String
		user: type: mongoose.Schema.ObjectId, ref: "Users"
		timestamp:
			type: Date
			default: Date.now
	]


exports.Tag = mongoose.model "Tags", new mongoose.Schema
	name: String


exports.Place = mongoose.model "Places", new mongoose.Schema
	facebookId: Number
	geoLocation: 
		type: [Number]
		index: '2d'
	users: [type: mongoose.Schema.ObjectId, ref: "Users"]
	questions: [type: mongoose.Schema.ObjectId, ref: "Questions"]


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