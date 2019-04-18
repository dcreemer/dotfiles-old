# java

if [[ -x "/usr/libexec/java_home" ]]; then
    # function that makes switching easy i.e. setjdk 1.8
    setjdk() {
        export JAVA_HOME=$(/usr/libexec/java_home -v $1)
    }
    setjdk 11
fi
