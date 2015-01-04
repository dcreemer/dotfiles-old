; based on https://gist.github.com/jamesmacaulay/5603176
;
{:user {:dependencies [[org.clojure/tools.namespace "0.2.8"]
                       [clj-time "0.9.0"]
                       [spyscope "0.1.5" :exclusions [clj-time]]
                       [criterium "0.4.3"]]
        :injections [; try/catch to workaround an issue where `lein repl` outside a project dir
                     ; will not load reader literal definitions correctly:
                     (try (require 'spyscope.core)
                          (catch RuntimeException e))]
        :plugins [[lein-ancient "0.5.5"]
                  [lein-localrepo "0.5.3"]
                  [lein-midje "3.1.3"]
                  [lein-kibit "0.0.8"]
                  [cider/cider-nrepl "0.8.2"]]}}
