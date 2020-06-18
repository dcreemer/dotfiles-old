
-- see https://github.com/Hammerspoon/hammerspoon/blob/master/LICENSE

---
--- Controls for Hermes music player
--- (https://github.com/HermesApp/Hermes)

local hermes = {}

local alert = require "hs.alert"
local as = require "hs.applescript"
local app = require "hs.application"

local applicationName = 'Hermes'
local applicationBundleID = "com.alexcrichton.Hermes"

--- hs.hermes.state_paused
--- Constant
--- Returned by `hs.hermes.getPlaybackState()` to indicates Hermes is paused
hermes.state_paused = "paus"

--- hs.hermes.state_playing
--- Constant
--- Returned by `hs.hermes.getPlaybackState()` to indicates Hermes is playing
hermes.state_playing = "play"

--- hs.hermes.state_stopped
--- Constant
--- Returned by `hs.hermes.getPlaybackState()` to indicates Hermes is stopped
hermes.state_stopped = "stop"

-- Internal function to pass a command to Applescript.
local function tell(cmd)
  local _cmd = 'tell application "' .. applicationName .. '" to ' .. cmd
  local ok, result = as.applescript(_cmd)
  if ok then
    return result
  else
    return nil
  end
end

--- hs.hermes.playpause()
--- Function
--- Toggles play/pause of current Hermes track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.playpause()
  tell('playpause')
end

--- hs.hermes.play()
--- Function
--- Plays the current Hermes track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.play()
  tell('play')
end

--- hs.hermes.pause()
--- Function
--- Pauses the current Hermes track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.pause()
  tell('pause')
end

--- hs.hermes.next()
--- Function
--- Skips to the next hermes track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.next()
  tell('next song')
end

--- hs.hermes.displayCurrentTrack()
--- Function
--- Displays information for current track on screen
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.displayCurrentTrack()
  local artist = tell('artist of the current song as string') or "Unknown artist"
  local album  = tell('album of the current song as string') or "Unknown album"
  local track  = tell('title of the current song as string') or "Unknown track"
  alert.show(track .."\n".. album .."\n".. artist, 1.75)
end

--- hs.hermes.getCurrentArtist() -> string or nil
--- Function
--- Gets the name of the current Artist
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the Artist of the current track, or nil if an error occurred
function hermes.getCurrentArtist()
    return tell('artist of the current song as string')
end

--- hs.hermes.getCurrentAlbum() -> string or nil
--- Function
--- Gets the name of the current Album
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the Album of the current track, or nil if an error occurred
function hermes.getCurrentAlbum()
    return tell('album of the current song as string')
end

--- hs.hermes.getCurrentTrack() -> string or nil
--- Function
--- Gets the name of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the name of the current track, or nil if an error occurred
function hermes.getCurrentTrack()
    return tell('title of the current song as string')
end

--- hs.hermes.getPlaybackState()
--- Function
--- Gets the current playback state of Hermes
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing one of the following constants:
---    - `hs.hermes.state_stopped`
---    - `hs.hermes.state_paused`
---    - `hs.hermes.state_playing`
function hermes.getPlaybackState()
   return tell('get playback state')
end

--- hs.hermes.isRunning()
--- Function
--- Returns whether Hermes is currently open. Most other functions in hs.hermes will automatically start the application, so this function can be used to guard against that.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether the Hermes application is running.
function hermes.isRunning()
   return app.get(applicationBundleID) ~= nil
end

--- hs.hermes.isPlaying()
--- Function
--- Returns whether Hermes is currently playing
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether Hermes is currently playing a track, or nil if an error occurred (unknown player state). Also returns false if the application is not running
function hermes.isPlaying()
   -- We check separately to avoid starting the application if it's not running
   if not hermes.isRunning() then
      return false
   end
   local state = hermes.getPlaybackState()
   if state == hermes.state_playing then
      return true
   elseif state == hermes.state_paused or state == hermes.state_stopped then
      return false
   else  -- unknown state
      return nil
   end
end

--- hs.hermes.getVolume()
--- Function
--- Gets the current Hermes volume setting
---
--- Parameters:
---  * None
---
--- Returns:
---  * A number, between 1 and 100, containing the current Hermes playback volume
function hermes.getVolume() return tell'playback volume' end

--- hs.hermes.setVolume(vol)
--- Function
--- Sets the Hermes playback volume
---
--- Parameters:
---  * vol - A number, between 1 and 100
---
--- Returns:
---  * None
function hermes.setVolume(v)
  v=tonumber(v)
  if not v then error('volume must be a number 0..100',2) end
  return tell('set playback volume to '..math.min(100,math.max(0,v)))
end

--- hs.hermes.volumeUp()
--- Function
--- Increases the Hermes playback volume by 5
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.volumeUp() return hermes.setVolume(hermes.getVolume()+5) end

--- hs.hermes.volumeDown()
--- Function
--- Decreases the Hermes playback volume by 5
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function hermes.volumeDown() return hermes.setVolume(hermes.getVolume()-5) end

--- hs.hermes.getPosition()
--- Function
--- Gets the playback position (in seconds) of the current song
---
--- Parameters:
---  * None
---
--- Returns:
---  * A number indicating the current position in the song
function hermes.getPosition() return tell('playback position') end

return hermes
