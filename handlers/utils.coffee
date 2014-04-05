location = require('../models/locations');
appid = '1422228611367342'
appsecret = '29792a86bc83aa86127eec74e868bbb3'

module.exports = {

	sendError : (socket, data) ->
		resp = {}
		resp.type = 'error'
		resp.info = data
		socket.emit resp
	,
	sendSuccess : (socket, data) ->
		resp = {}
		resp.type = 'success'
		resp.info = data
		socket.emit resp
	,
	###
	oauth/access_token?grant_type=fb_exchange_token&client_id=1422228611367342&client_secret=29792a86bc83aa86127eec74e868bbb3&fb_exchange_token=1422228611367342|c36Bm6lAdSS3_UbjCPVY5A53JTM
	"place": {
	        "id": "333816313359586", 
	        "name": "Cross Campus", 
	        "location": {
	          "city": "Santa Monica", 
	          "country": "United States", 
	          "latitude": 34.018656040043, 
	          "longitude": -118.48898943976, 
	          "state": "CA", 
	          "street": "929 Colorado Ave", 
	          "zip": "90401"
	}


	Places = mongoose.model "Places", new mongoose.Schema
		facebookId: Number
		geoLocation: 
			type: [Number]
			index: '2d'
		users: [type: mongoose.Schema.ObjectId, ref: "Users"]
		questions: [type: mongoose.Schema.ObjectId, ref: "Questions"]

	###
	getUserId : (token, done) ->
		FB = require('fb')
		FB.setAccessToken(token)
		res = {}
		FB.api '/me', (res) ->
			if not res? or res.error?
		   		console.log 'Could not find user Facebook Id'
		   		return done new Error 'UserId not found'
		   	res.userId = res.id
		   	#https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=<APP_ID>&client_secret=<APP_SECRET>&fb_exchange_token=<SHORT_LIVED_TOKEN>
		   	FB.api 'oauth/access_token', { grant_type : fb_exchange_token, client_id : appid, client_secret: appsecret,  fb_exchange_token: token }, (res) -> 
		   		if not res? or res.error?
		   			console.log 'Could not find user long lived token'
		   			return done new Error 'Could not find long lived token'
		   		res.token = res.token #TEST TODO
		   		return done null, res
    ,
	makeLocation : (loc, done) ->
		dbLoc = {}
		dbLoc.facebookId = loc.id
		dbLoc.users = []
		dbLoc.questions = []
		dbLoc.geoLocation = {longitude : loc.longitude , latitude : loc.latitude }
		done dbLoc
	,
	makeUser : (userInfo, done) ->
		dbUser = {}
		dbUser.facebookId = userInfo.userId
		dbUser.name = userInfo.userName
		dbUser.token = userInfo.token
		dbUser.notificationsSet = 10
		dbUser.reputation = 0
		done dbUser
	,

	populateLocations : (userId, token) -> ## Add pagination
		FB = require('fb')
		FB.setAccessToken(token)

		FB.api '/#{userId}/locations', (res) ->
		  	if not res? or res.error?
		   		return console.log 'Could not find any location'

		  	if res.data? and res.data.length > 0	
		    	for data in res.data
		    		if res.data.place?
		    			location.byId res.data.place.id, (err, loc) ->
		    				if not loc? and not err?
		    					makeLocation res.data.place, (dbLoc) ->
				    				location.add dbLoc, (err, resp) ->
				    					if err? 
				    						console.log err
				    					else 
				    						console.log 'Success for location : {#resp.facebookId}'  
		    				else if loc? and not err?
		    					location.addCheckedInUser userId, loc._id, (err, resp) ->
									if err? 
			    						console.log err
			    					else 
			    						console.log 'Success for adding checked in user : {#userId}'  	    						
}
	    			
 



