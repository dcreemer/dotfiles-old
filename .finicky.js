module.exports = {
  defaultBrowser: "Firefox",
  handlers: [
    {
      match: finicky.matchHostnames("docs.google.com"),
      browser: "Google Chrome"
    },
    {
      match: finicky.matchHostnames(["tailscale.com", "login.tailscale.com"]),
      browser: "Google Chrome"
    },
    {
      match: /^https?:\/\/([a-z0-9]+\.)?zoom\.us\/j\/.*$/,
      browser: "us.zoom.xos"
    },
    {
      match: /^https?:\/\/.*box\.com\/.*$/,
      browser: "Safari"
    },
    {
      match: /^https?:\/\/.*webex\.com\/.*$/,
      browser: "Safari"
    },
    {
      match: /^https?:\/\/.*icloud\.com\/.*$/,
      browser: "Safari"
    },
    {
      match: /^https?:\/\/.*enterprise\.slack\.com\/.*$/,
      browser: "Safari"
    },
    {
      match: /^https?:\/\/quip\-a....\.com\/.*$/,
      browser: ["com.quip.Desktop", "Safari" ]
    },
    {
      match: /^https?:\/\/.*apple\.com\/.*$/,
      browser: "Safari"
    },
  ]
}
