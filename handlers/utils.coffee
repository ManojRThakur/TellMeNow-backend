location = require '../models/location'
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
		FB.api '/me', (resp) ->
			if not res? or res.error?
				console.log 'Could not find user Facebook Id ' + res.error
				return done new Error 'UserId not found'
			res.userId = resp.id
			res.userName = resp.username
			#https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=<APP_ID>&client_secret=<APP_SECRET>&fb_exchange_token=<SHORT_LIVED_TOKEN>
			test = { grant_type : "fb_exchange_token", client_id : appid, client_secret: appsecret,  fb_exchange_token: token }
			FB.api 'oauth/access_token', { grant_type : "fb_exchange_token", client_id : appid, client_secret: appsecret,  fb_exchange_token: token }, (resp) -> 
				if not resp? or resp.error?
					console.log 'Could not find user long lived token ' + JSON.stringify resp.error
					return done new Error 'Could not find long lived token'

				res.token = resp.access_token #TEST TODO
				return done null, res
	,
	makeLocation : (loc, done) ->
		dbLoc = {}
		dbLoc.facebookId = parseInt loc.id
		dbLoc.users = []
		dbLoc.questions = []
		dbLoc.geoLocation = {"lng": loc.location.longitude , "lat": loc.location.latitude }
		dbLoc.name = loc.name
		done dbLoc
	,
	makeUser : (userInfo, done) ->
		dbUser = {}
		dbUser.facebookId = parseInt userInfo.userId
		dbUser.name = userInfo.userName
		dbUser.token = userInfo.token
		dbUser.notificationsSet = 5
		done dbUser
	,
	addSubscription : (socket, type, ids, done) ->
		for id in ids
			if socket.subscription is undefined
				socket.subscription = {}
				socket.subscription[type] = []
			else if socket.subscription isnt undefined and socket.subscription[type] is undefined
				socket.subscription[type] = []
			if (socket.subscription[type].indexOf id) is -1
				socket.subscription[type].push id
		do done
	,
	actOnSubscriptionResponse : (socket, type, id, done) ->
		console.log socket.subscription
		if socket.subscription isnt undefined and socket.subscription[type] isnt undefined 
			if (socket.subscription[type].indexOf id) >= 0 or type is 'location'
				console.log 'entered?'
				socket.emit '/subscription', {"type":type, "id": id} 
		do done
	,
	populateLocations : (socket, userId, token) -> ## Add pagination
		FB = require 'fb' 
		FB.setAccessToken(token)

		FB.api '/me/locations', {} ,  (res) ->
			if not res? or res.error?
				return console.log 'Could not find any location'
			if res.data? and res.data.length > 0	
				for data in res.data
					if data.place?
						module.exports.makeLocation data.place, (dbLoc) ->
							location.postLocationByFacebookId dbLoc.facebookId, dbLoc, (err, loc) ->	
								if err? 
									console.log err
								else 
									if not loc?
										location.postLocation dbLoc, (err, loc) ->
											if err? 
												console.log err
											console.log 'Success for location : {#resp.facebookId}'
											userIds = userId
											location.addUsers { users : userIds, _id : loc._id }, (err, resp) ->
												if err? 
													console.log err
												else 
													console.log 'Success for adding checked in user : {#userId}'
													# add for notification  
													module.exports.actOnSubscriptionResponse socket, 'user', loc._id, () ->
														
									else
										userIds = userId
										location.addUsers { users : userIds, _id : loc._id }, (err, resp) ->
											if err?
												console.log err
											else
												console.log 'Success for adding checked in user : {#userId}'
												module.exports.actOnSubscriptionResponse socket, 'location', loc._id, () ->

}
					
 



