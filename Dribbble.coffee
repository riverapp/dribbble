class Dribbble

	constructor: (delegate) ->
		@delegate = delegate


	authRequirements: (callback) ->
		callback {
			authType: 'basic',
			fields: [
				{
					label: 'Username',
					type: 'text',
					identifier: 'username'
				}
			]
		}


	authenticate: (params) ->
		HTTP.get "http://api.dribbble.com/players/#{params.username}", (err, user) =>
			if err
				return console.log(err)
			user = JSON.parse(user)
			@delegate.createAccount {
				name: user.name,
				identifier: user.username,
				secret: user.username
			}
			

	update: (user, callback) ->
		HTTP.get "http://api.dribbble.com/players/#{user.identifier}/shots/following", (err, response) =>
			if err
				return callback(err, null)
			data = JSON.parse(response)
			shots = []
			for d in data.shots
				shot = new Image()
				shot.title = d.title
				shot.creator = d.player.name
				shot.creatorImageURL = d.player.avatar_url
				shot.imageURL = d.image_url
				shot.imageHeight = d.height
				shot.imageWidth = d.width
				shots.push(shot)
			callback(null, shots)


	updatePreferences: (callback) ->
		callback {
			interval: 900,
			min: 600,
			max: 3600
		}


PluginManager.registerPlugin(Dribbble, 'me.danpalmer.River.plugins.Dribbble')