define [
	"jquery"
	"underscore"
	"backbone"
	"App"
], ($, _, Backbone, app) ->
	class FlickrController extends Backbone.Marionette.Controller
		apiKey: 'e400c83e08716edc21ce04d19a71d697'
		groupId: '46744914%40N00'

		initialize: (options) ->
			_.bindAll @

			@urls = 
				base: "http://api.flickr.com/services/rest/?api_key=#{@apiKey}&group_id=#{@groupId}&format=json&nojsoncallback=1"
				topics: "&method=flickr.groups.discuss.topics.getList"
				user: "&method=flickr.people.getInfo"
				replies: "&method=flickr.groups.discuss.replies.getList"
			

		topics: (perPage = 20, page = 1, success, fail) ->
			url = @urls.base + @urls.topics + @perPage(perPage) + @page(page)

			@ajaxPetition(url, @processTopic, success, fail)

		user: (userId, success, fail) ->
			url = @urls.base + @urls.user + @userId(userId)

			@ajaxPetition(url, @processUser, success, fail)

		replies: (topicId, perPage = 20, page = 1, success, fail) ->
			url = @urls.base + @urls.replies + @perPage(perPage) + @page(page) + @topicId(topicId)

			@ajaxPetition(url, @processReplies, success, fail)

		onSuccess: (result) ->
			@topics = result

		onFail: (fail) ->
			return

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
				reply.nsid = reply.author
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
				nsid = user.nsid
				"http://farm#{iconfarm}.staticflickr.com/#{iconserver}/buddyicons/#{nsid}.jpg"
			else
				"http://www.flickr.com/images/buddyicon.gif"

		processTopic: (msg) ->
			topics = msg.topics.topic
			result = []
			
			_.each(topics, (topic) ->
				try
					content = $(topic.message._content)
					imgs = content.find('img')

					if imgs.length == 5
						topic.frames = []
						_.each(imgs, (img) -> 
							@frames.push({src: img.src})
						, topic)
						@push(topic)
				catch error
					

			, result)

			result


	new FlickrController()








