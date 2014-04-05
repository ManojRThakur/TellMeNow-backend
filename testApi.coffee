FB = require 'fb'
FB.setAccessToken 'CAACEdEose0cBAOUMZAq6roAxeMx4yCH9pzXkWoayCx0ifiNdwUNWaceXXZAvZBXCbwRVun4plZBcZA7zz8c5JMTYX5a26ZAQn28esz5EA2xcjebG6m19BCbglVjlY6gL07cLvVPM2X2pGlrEy57XMMnfujRo7iZAsUs72LXjpgmVJifzM6SElkw0Qi6cvsZBLqF5js1tUjaYJwZDZD'

FB.api '/me/locations', (res) ->
  if not res? or res.error?
   console.log 'error'
  
  if res.data? and res.data.length > 0
    for data in  res.data
    	console.log 'PLACE ---->'
    	console.log data.place