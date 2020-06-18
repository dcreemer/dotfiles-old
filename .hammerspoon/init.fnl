;;
;; Hammerspoon Configuration
;;
;; Note that I'm using Fennel (https://github.com/bakpakin/Fennel),
;; a nice LISP written in Lua.
;;

;; Setup logging
(local log (hs.logger.new "dcreemer" "info"))
(log.i "loading init.fnl")

;; my "hyper" key
(local hyper ["cmd" "alt" "ctrl"])

;; Load the SpoonInstall spoon and create a nice alias
(local Install (let [s (hs.loadSpoon "SpoonInstall")]
                 (set s.use_syncinstall true)
                 s))

;; Bind reload config
(hs.hotkey.bind hyper "0" hs.reload)

;; Where is my mouse?
(Install:andUse "MouseCircle"
                {:hotkeys {:show [hyper "M"]}})

;; Show help
(Install:andUse "KSheet"
                {:hotkeys {:toggle [hyper "/"]}})

;; Window manipulation with hyper-arrows.
(set hs.window.animationDuration 0.1)
(Install:andUse "MiroWindowsManager"
                {:hotkeys {:up         [hyper "up"]
		           :right      [hyper "right"]
		           :down       [hyper "down"]
		           :left       [hyper "left"]
		           :fullscreen [hyper "f"]}})

;; Control Hermes
(local hermes (require "hermes"))

(fn handle-hermes-event [event]
  (let [systemKey (event:systemKey)
        flags (event:getFlags)
        propogate (match [systemKey.key systemKey.down flags.shift]
                    ["PLAY" true true] (hermes.displayCurrentTrack)
                    ["PLAY" true nil]  (if (hermes.isRunning)
                                           (hermes.playpause)
                                           (do (hs.application.launchOrFocusByBundleID
                                                "com.alexcrichton.Hermes") nil))
                    ["FAST" true _]    (hermes.next)
                    _ true)]
    (if propogate nil true)))

(let [hermes-tap (hs.eventtap.new [hs.eventtap.event.types.flagsChanged
                                   hs.eventtap.event.types.NSSystemDefined]
                                  handle-hermes-event)]
  (hermes-tap:start))

;; URL Handling

;; browsers:
(local DefaultBrowser "org.mozilla.firefox")
(local Zoom "us.zoom.xos")
(local Safari "com.apple.Safari")
(local Chrome "com.google.Chrome")
(local Tweetbot "com.tapbots.Tweetbot3Mac")
(local ChromeApp "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")

(lambda make-tweetbot-url [url]
  ;; open URLs that Tweetbot can handle in Tweetbot, otherwise use default
  ;; idea from https://github.com/robmathers/tweetbotlinks
  (let [u (-> url
              (string.gsub "https?://www%.twitter%.com" "")
              (string.gsub "https?://mobile%.twitter%.com" "")
              (string.gsub "https?://twitter%.com" "")
              (string.gsub "#!/" "")
              (string.gsub "/statuses/" "/status/"))]
    (if
     (string.match u "/status/" 1 true) (.. "tweetbot:/" u)
     (string.match u "^/[%w_]+/?$") (.. "tweetbot:/user_profile" u)
     (string.match u "^/search%?") (.. "tweetbot:" (string.gsub u "q=" "query="))
     (values nil u))))

(lambda tweetbot [url]
  (let [new-url (make-tweetbot-url url)]
    (if (= new-url url)
        (hs.urlevent.openURLWithBundle url DefaultBrowser)
        (hs.urlevent.openURLWithBundle new-url Tweetbot))))

(lambda chrome-with-profile [profile url]
  ;; open Chrome with a specific named profile
  (let [args [(.. "--profile-directory=" profile) url]
        t (hs.task.new ChromeApp nil #false args)]
    (t:start)))

(local chrome-work (partial chrome-with-profile "Profile 1"))
(local chrome-default (partial chrome-with-profile "Default"))

(Install:andUse "URLDispatcher"
                {:config
                 {:url_patterns [["https?://zoom.us/j/"              Zoom ]
		                 ["https?://%w+.zoom.us/j/"    Zoom ]
		                 ["https?://%w+.atlassian.net" nil chrome-work ]
		                 ["https?://docs.google.com"         nil chrome-work ]
		                 ["https?://meet.google.com"         nil chrome-default ]
		                 ["https?://maps.google.com"         nil chrome-default ]
		                 ["https?://google.com/maps"         nil chrome-default ]
		                 ["https?://apple.com"               Safari ]
		                 ["https?://www.apple.com"           Safari ]
		                 ["https?://twitter.com"             nil tweetbot ]
		                 ["https?://mobile.twitter.com"      nil tweetbot ]
		                 ["https?://www.twitter.com"         nil tweetbot ]]
		  :default_handler DefaultBrowser}
                 :start true})
