#!/bin/zsh

execute_java () {

    start=`date +%s`
    java.bin $ARGS

    end=`date +%s`
    runtime=$((end-start))

    if (( $runtime > 1 )); then
        terminal-notifier -title "$1" -message "Operation completed"
    fi
}

ARGS=( "$@" )

if [[ ! "$*" == *" -v"* && ! "$*" == *" --version"* ]]; then

    if [[ "$*" == *"maven.home"* ]]; then
        execute_java "Maven"
    elif [[ "$*" == *"GradleWorkerMain"* ]]; then
        execute_java "Gradle"
    else
        java.bin "$@"
    fi
else
    java.bin "$@"
fi
