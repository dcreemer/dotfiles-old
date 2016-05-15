; based on https://gist.github.com/jamesmacaulay/5603176
;
{:user {:dependencies [[org.clojure/tools.namespace "0.2.10"]
                       [org.clojure/tools.nrepl "0.2.12"]
                       [clj-time "0.11.0"]
                       [spyscope "0.1.5" :exclusions [clj-time]]
                       [criterium "0.4.4"]]
        :injections [; try/catch to workaround an issue where `lein repl` outside a project dir
                     ; will not load reader literal definitions correctly:
                     (try (require 'spyscope.core)
                          (catch RuntimeException e))]
        :plugins [[lein-ancient "0.6.10"]
                  [lein-localrepo "0.5.3"]
                  [lein-midje "3.2"]
                  [lein-kibit "0.1.2"]]}}
