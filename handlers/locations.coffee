location = require('../models/location');

module.exports = 
	getSuggestedLocations : (data, done) ->
		location.getPlacesByCoordinates data, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp

	getQuestionsNearby : (data, done) ->
		location.getPlacesByCoordinates data, (err, resp) ->
			if err?
				return done err
			else
				results = []
				for res in resp
					res = res.toJSON()
					for question in res.questions
						results.push question
				return done null, results
	
	getSuggestedLocationsByKeyword : (keyword, done) ->
		location.getLocationByKeyword keyword, (err, data) ->
			if err?
				return done err
			else
				return done null, data

	getLocationById : (ids, done) ->
		location.getLocationByIdInArray ids, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp