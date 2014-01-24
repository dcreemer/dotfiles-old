; based on https://gist.github.com/jamesmacaulay/5603176
;
{:user {:dependencies [[org.clojure/tools.namespace "0.2.4"]
                       [spyscope "0.1.4" :exclusions [clj-time]]
                       [criterium "0.4.2"]]
        :injections [(require '(clojure.tools.namespace repl find))
                     ; try/catch to workaround an issue where `lein repl` outside a project dir
                     ; will not load reader literal definitions correctly:
                     (try (require 'spyscope.core)
                          (catch RuntimeException e))]
        :plugins [[lein-pprint "1.1.1"]
                  [lein-kibit "0.0.8" :exclusions [org.clojure/clojure]]
                  [lein-ancient "0.5.4" :exclusions [commons-codec]]]}}
