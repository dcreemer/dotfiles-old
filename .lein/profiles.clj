; based on https://gist.github.com/jamesmacaulay/5603176
;
{:user {:dependencies [[org.clojure/tools.namespace "0.2.5"]
                       [clj-time "0.8.0"]
                       [spyscope "0.1.4" :exclusions [clj-time]]
                       [criterium "0.4.3"]]
        :injections [(require '(clojure.tools.namespace repl find))
                     ; try/catch to workaround an issue where `lein repl` outside a project dir
                     ; will not load reader literal definitions correctly:
                     (try (require 'spyscope.core)
                          (catch RuntimeException e))]
        :plugins [[lein-pprint "1.1.1"]
                  [lein-ancient "0.5.5"]
                  [lein-localrepo "0.5.3"]
                  [cider/cider-nrepl "0.7.0"]]}}
