# java

if [[ -x "/usr/libexec/java_home" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
fi
