define [
	"jquery"
	"underscore"
	"backbone"
	"App"
], ($, _, Backbone, app) ->
	class FlickrController extends Backbone.Marionette.Controller
		apiKey: 'INSERT YOUR API KEY HERE'
		groupId: '46744914%40N00'

		initialize: (options) ->
			_.bindAll @

			@urls = 
				base: "http://api.flickr.com/services/rest/?api_key=#{@apiKey}&group_id=#{@groupId}&format=json&nojsoncallback=1"
				topics: "&method=flickr.groups.discuss.topics.getList"
				user: "&method=flickr.people.getInfo"
			

		topics: (perPage = 20, page = 1, success, fail) ->
			url = @urls.base + @urls.topics + @perPage(perPage) + @page(page)

			@ajaxPetition(url, @processTopic, success, fail)

		user: (userId, success, fail) ->
			url = @urls.base + @urls.user + @userId(userId)

			@ajaxPetition(url, )

		onSuccess: (result) ->
			@topics = result

		onFail: (fail) ->
			return

		perPage: (perPage) ->
			"&per_page=#{perPage}"

		page: (page) ->
			"&page=#{page}"

		userId: (user_id) ->
			"&user_id=#{user_id}"

		ajaxPetition: (url, process, successCallback, failCallback) ->
			$.ajax
				type: "GET"
				url: url
				success: (msg) -> 
					successCallback(process(msg))
				fail: (msg) ->
					failCallback(msg)

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








