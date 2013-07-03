define [
	"jquery"
	"underscore"
	"backbone"
	"marionette"
], ($, _, Backbone) ->
	class FlickrController extends Backbone.Marionette.Controller
		apiKey: '55ec26d53c16abec5dca3c72e76ece71'
		groupId: '46744914%40N00'

		initialize: ->
			_.bindAll @

			@urls = 
				base: "http://api.flickr.com/services/rest/?api_key=#{@apiKey}&group_id=#{@groupId}&format=json&nojsoncallback=1"
				topics: "&method=flickr.groups.discuss.topics.getList"
				user: "&method=flickr.people.getInfo"
				replies: "&method=flickr.groups.discuss.replies.getList"
			

		topics: (perPage = 20, page = 1, success = @onSuccess, fail = @onFail) ->
			url = @urls.base + @urls.topics + @perPage(perPage) + @page(page)

			@ajaxPetition(url, @processTopic, success, fail)

		user: (userId, success, fail) ->
			url = @urls.base + @urls.user + @userId(userId)

			@ajaxPetition(url, @processUser, success, fail)

		replies: (topicId, perPage = 20, page = 1, success = @onSuccess, fail = @onFail) ->
			url = @urls.base + @urls.replies + @perPage(perPage) + @page(page) + @topicId(topicId)

			@ajaxPetition(url, @processReplies, success, fail)

		onFail: (msg) ->
			console.log("Flickr call failed:", msg)

		onSuccess: (msg) ->
			console.log("Flickr call success:", msg)

		perPage: (perPage) ->
			"&per_page=#{perPage}"

		page: (page) ->
			"&page=#{page}"

		userId: (userId) ->
			"&user_id=#{userId}"

		topicId: (topicId) ->
			"&topic_id=#{topicId}"
			

		ajaxPetition: (url, process, successCallback, failCallback) ->
			$.ajax
				type: "GET"
				url: url
				success: (msg) -> 
					successCallback(process(msg))
				fail: (msg) ->
					failCallback(msg)


		processReplies: (msg) ->
			replies = msg.replies.reply
			result = []

			buildAvatar = @buildAvatarURL

			_.each(replies, (reply) -> 
				reply.avatar = buildAvatar(reply)
				result.push(reply)
			)

			result

		processUser: (msg) ->
			user = msg.person
			user.avatar = @buildAvatarURL(user)

			user

		buildAvatarURL: (user) ->
			# Avatar url must be built using information of the user
			iconserver = user.iconserver

			if iconserver > 0
				iconfarm = user.iconfarm
				nsid = if user.nsid then user.nsid else user.author
				"http://farm#{iconfarm}.staticflickr.com/#{iconserver}/buddyicons/#{nsid}.jpg"
			else
				"http://www.flickr.com/images/buddyicon.gif"

		buildImgURL: (url) ->


		processTopic: (msg) ->

			console.log msg
			topics = msg.topics.topic
			result = []
			buildAvatarURL = @buildAvatarURL

			_.each(topics, (topic) ->
				try
					content = $(topic.message._content)
					imgs = content.find('img')

					if imgs.length == 5
						topic.frames = []
						topic.thumbnails = []

						# We build the frame array out of the content of the message
						i = 0
						_.each(imgs, (img) -> 
							# preProcess the src to create the low and hi res
							src = img.src
							startSize = src.lastIndexOf('_')
							if src.charAt(startSize+2) != '.'
								startSize = src.lastIndexOf('.')

							srcBase = src.substr(0, startSize) 

							# low_res
							@thumbnails.push({src: srcBase + if i == 0 then "_q.jpg" else "_s.jpg"})

							# hi_res
							@frames.push({src: srcBase + ".jpg"})

							i++
						, topic)

						# Avatar generation
						topic.avatar = buildAvatarURL(topic)

						@push(topic)

				catch error


			, result)

			result


	new FlickrController()








