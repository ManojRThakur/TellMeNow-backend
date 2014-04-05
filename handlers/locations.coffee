location = require('../models/location');

module.exports = 
	getSuggestedLocations : (data, done) ->
		console.log data
		location.getPlacesByCoordinates data, (err, data) ->
			if err?
				return done err
			else
				return done null, data
				
