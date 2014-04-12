schema = require './schema'

exports.postLocation = (data, callback) ->
	place = new schema.Place
		facebookId: data.facebookId
		name: data.name
		geoLocation: [ data.geoLocation.lng, data.geoLocation.lat]
		users: data.users
	place.save (err, pl) ->
		return callback err if err?
		return callback null, pl


exports.updateName = (data, callback) ->
	schema.Place.findOneAndUpdate {_id: data._id}, name: data.name, (err, pl) ->
		return callback err if err?
		return callback null, pl


exports.updateGeoLocation = (data, callback) ->
	schema.Place.findOneAndUpdate {_id: data._id}, {geoLocation: [data.geoLocation.lng, data.geoLocation.lat]}, (err, pl) ->
		return callback err if err?
		return callback null, pl


exports.addQuestions = (data, callback) ->
	schema.Place.findOneAndUpdate {_id: data._id}, {$addToSet: {questions: data.questions}}, (err, pl) ->
		return callback err if err?
		return callback null, pl


exports.addUsers = (data, callback) ->
	schema.Place.findOneAndUpdate {_id: data._id}, {$addToSet: {users: data.users}}, (err, pl) ->
		return callback err if err?
		return callback null, pl


exports.getLocation = (id, callback) ->
	schema.Place.findOne _id: id, (err, pl) ->
		return callback err if err?
		return callback null, pl

exports.getPlacesByCoordinates = (data, callback) ->
	console.log data
	#schema.Place.find geoLocation: $near : $center: [ [ data.geoLocation.lng, data.geoLocation.lat ], 20/3959 ], (err, loc) ->
	schema.Place.find geoLocation: $near : $geometry: { type:"Point", coordinates:[data.geoLocation.lng, data.geoLocation.lat] }, $maxDistance:20000, (err, loc) ->
		return callback err if err?
		return callback null, loc
	#schema.Place.find geoLocation: $near: $geometry: {type: "Point", coordinates : [ data.geoLocation.lng , data.geoLocation.lat ]}, $maxDistance : 20/3959, (err, loc) ->
	#	return callback err if err?
	#	return callback null, loc

exports.postLocationByFacebookId = (facebookId, data, callback) ->
	facebookId = parseInt(facebookId)
	schema.Place.findOneAndUpdate {facebookId: facebookId}, data, (err, pl) ->
		return callback err if err?
		return callback null, pl

exports.getLocationByFacebookId = (facebookId, callback) ->
	facebookId = parseInt(facebookId)
	schema.Place.find {facebookId: facebookId} , (err, pl) ->
		return callback err if err?
		return callback null, pl

exports.getLocationByKeyword = (keyword, callback) ->
	schema.Place.find { name: { $regex: new RegExp keyword.query ,"i" } }, (err, resp) ->
		return callback err if err?
		return callback null, resp

exports.upsertUserCheckin = (data, callback) ->
	console.log data
	schema.Place.update { facebookId: data.facebookId },
		$setOnInsert: 
			facebookId: data.facebookId
			name: data.name
			geoLocation:
				lng: data.geoLocation.lng
				lat: data.geoLocation.lat 
		$push: 
			users: data.userId
		upsert: true
	, (err, pl) ->
		return callback err if err?
		return callback null, pl