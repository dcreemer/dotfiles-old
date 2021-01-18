local log = hs.logger.new('dcreemer','info')
log.i('Initializing')

-- my "hyper" key is this
local hyper = { "cmd", "alt", "ctrl" }

-- Install Spoons with SpoonInstall
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

-- reload config
hs.hotkey.bind(hyper, "0", function()
	hs.notify.new(nil, {
		title = "Hammerspoon",
		subTitle = "Configuration reloading!",
		withdrawAfter = 2,
		autoWithdraw = true,
	}):send()
	hs.reload()
 end)

-- Where is my mouse?
Install:andUse("MouseCircle", {
	hotkeys = {
		show = {hyper, "M"},
	}
})

-- Window Manipulation with hyper-arrows.
hs.window.animationDuration = 0.1
Install:andUse("MiroWindowsManager", {
	hotkeys = {
		up = {hyper, "up"},
		right = {hyper, "right"},
		down = {hyper, "down"},
		left = {hyper, "left"},
		fullscreen = {hyper, "f"}
	}
})

-- System-wide URL handling
-- Handle various kinds of URLs in different browsers

DefaultBrowser = "org.mozilla.firefox"
Zoom = "us.zoom.xos"
Safari = "com.apple.Safari"
Chrome = "com.google.Chrome"
Tweetbot = "com.tapbots.Tweetbot3Mac"
Webex = "com.webex.meetinmanager"
Quip = "com.quip.Desktop"
ChromeApp = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

-- open Chrome with a specific named Profile
function chromeWithProfile(profile, url)
	local t = hs.task.new("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
		nil,
		function() return false end,
		{"--profile-directory=" .. profile, url})
	t:start()
end

chromeDefault = hs.fnutils.partial(chromeWithProfile, "Default")

-- open URLs that Tweetbot can handle in Tweetbot, otherwise use default
-- idea from https://github.com/robmathers/tweetbotlinks
function tweetbot(url)
	url = string.gsub(url, "https?://www%.twitter%.com", "")
	url = string.gsub(url, "https?://mobile%.twitter%.com", "")
	url = string.gsub(url, "https?://twitter%.com", "")
	url = string.gsub(url, "#!/", "")
	url = string.gsub(url, "/statuses/", "/status/")
	if string.match(url, "/status/", 1, true) then
		url = "tweetbot:/" .. url
	elseif string.match(url, "^/[%w_]+/?$") then
		url = "tweetbot:/user_profile" .. url
	elseif string.match(url, "^/search%?") then
		url = "tweetbot:" .. string.gsub(url, "q=", "query=")
	else
		hs.urlevent.openURLWithBundle(url, DefaultBrowser)
	end
	hs.urlevent.openURLWithBundle(url, Tweetbot)
end

-- handle quip URLs in the Quip application
function tryOpenQuip(id)
	local idl = string.len(id)
	log.i("tryOpenQuip", idl, id)
	if id ~= nil and (idl == 11 or idl == 12 or idl == 24) then
		local url = "quip://" .. id
		log.i("tryOpenQuip", url)
		hs.urlevent.openURLWithBundle(url, Quip)
		return true
	end
	return false
end

function quip(url)
	local _, _, emailId = string.find(url, "thread_id=(%w+)")
	local _, _, bareId = string.find(url, "https://quip[%a%-]+%.com/([%w#]+)")
	return tryOpenQuip(bareId) or tryOpenQuip(emailId)
end

Install:andUse("URLDispatcher", {
	config = {
		url_patterns = {
			{ "https?://zoom%.us/j/",              Zoom },
			{ "https?://%w+%.zoom%.us/j/",         Zoom },
			{ "https://quip[%a%-]+%.com/",         nil, quip },
			{ "https?://.*box%.com",               Safari },
			{ "https?://.*apple%.com",             Safari },
			{ "https?://.*webex%.com",             Safari },
			{ "https?://.*icloud%.com",            Safari },
			{ "https?://.*enterprise%.slack%.com", Safari },
			{ "https?://docs%.google%.com",        nil, chromeDefault },
			{ "https?://twitter%.com",             nil, tweetbot },
			{ "https?://mobile%.twitter%.com",     nil, tweetbot },
			{ "https?://www%.twitter%.com",        nil, tweetbot },
		},
		default_handler = DefaultBrowser
	},
	start = true,
})
