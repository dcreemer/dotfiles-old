local log = hs.logger.new('dcreemer','info')
log.i('Initializing')

-- my "hyper" key is this
local hyper = { "cmd", "alt", "ctrl" }

-- Install Spoons with SpoonInstall
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

-- reload config
hs.hotkey.bind(hyper, "0", hs.reload)

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

function chromeWithProfile(profile, url)
	-- open Chrome with a specific named Profile
	local t = hs.task.new("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
		nil,
		function() return false end,
		{"--profile-directory=" .. profile, url})
	t:start()
end

chromeDefault = hs.fnutils.partial(chromeWithProfile, "Default")
chromeWork = hs.fnutils.partial(chromeWithProfile, "Profile 1")

function tweetbot(url)
	-- open URLs that Tweetbot can handle in Tweetbot, otherwise use default
	-- idea from https://github.com/robmathers/tweetbotlinks
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

Install:andUse("URLDispatcher", {
	config = {
		url_patterns = {
			{ "https?://zoom.us/j/",              Zoom },
			{ "https?://%w+.zoom.us/j/",          Zoom },
			{ "https?://flipboard.atlassian.net", nil, chromeWork },
			{ "https?://docs.google.com",         nil, chromeWork },
			{ "https?://meet.google.com",         nil, chromeDefault },
			{ "https?://maps.google.com",         nil, chromeDefault },
			{ "https?://google.com/maps",         nil, chromeDefault },
			{ "https?://apple.com",               Safari },
			{ "https?://www.apple.com",           Safari },
			{ "https?://twitter.com",             nil, tweetbot },
			{ "https?://mobile.twitter.com",      nil, tweetbot },
			{ "https?://www.twitter.com",         nil, tweetbot },
		},
		default_handler = DefaultBrowser
	},
	start = true,
})

-- help
Install:andUse("KSheet", {
	hotkeys = {
		toggle = {hyper, "/"},
	}
})

-- Control Hermes with system Media Keys
hermes = require "hermes"

-- TODO: control playing music player only. Launch favorite one if none playing
myEventtap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.NSSystemDefined }, function(event)
    local systemKey = event:systemKey()
    -- log.i(hs.inspect.inspect(systemKey))
    if systemKey.down then
		local flags = event:getFlags()
		if systemKey.key == "PLAY" then
			if flags.shift then
				hermes.displayCurrentTrack()
			else
				hermes.playpause()
			end
			-- return true to not propogate event, so iTunes/Music is not launched
			return true
		elseif systemKey.key == "FAST" then
			hermes.next()
		end
    end
end):start()
