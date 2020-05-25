local log = hs.logger.new('dcreemer','info')
log.i('Initializing')

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

Install = spoon.SpoonInstall

local hyper = { "cmd", "alt", "ctrl" }

Install:andUse("MouseCircle",
               {
                   hotkeys = {
                       show = {hyper, "M"}
                   }
               }
)

DefaultBrowser = "org.mozilla.firefox"
Zoom = "us.zoom.xos"
Safari = "com.apple.Safari"
Chrome = "com.google.Chrome"

function chromeWithProfile(profile, url)
  local t = hs.task.new("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
                        nil,
                        function() return false end,
                        {"--profile-directory=" .. profile, url})
  t:start()
end

function tweetbot(url)
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
	hs.urlevent.openURLWithBundle(url, "com.tapbots.Tweetbot3Mac")
end

chromeDefault = hs.fnutils.partial(chromeWithProfile, "Default")
chromeWork = hs.fnutils.partial(chromeWithProfile, "Profile 1")

Install:andUse("URLDispatcher",
               {
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
                 start = true
               }
)

Install:andUse("KSheet",
               {
                 hotkeys = {
                   toggle = {hyper, "/"}
}})


expose = hs.expose.new(nil,{ includeOtherSpaces = true, showThumbnails = false })
hs.hotkey.bind('ctrl-alt-cmd', 'e', 'Expose', function() expose:toggleShow() end)

hs.hotkey.bind(hyper, "0", function() hs.reload() end)

hermes = require "hermes"

-- Control Hermes with system Media Keys
myEventtap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.NSSystemDefined }, function(event)
    local systemKey = event:systemKey()
    -- log.i(hs.inspect.inspect(systemKey))
    if systemKey.down then
		if systemKey.key == "PLAY" then
			hermes.playpause()
		elseif systemKey.key == "FAST" then
			hermes.next()
		end
    end
end):start()
