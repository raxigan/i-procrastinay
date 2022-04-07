
DIR=$(dirname "$0")

execute_java () {

    start=`date +%s`
    ${DIR}/java.bin $ARGS

    end=`date +%s`
    runtime=$((end-start))

    if (( $runtime > 1 )); then
        notify "$1" "Operation completed"
    fi
}

ARGS=( "$@" )

if [[ ! "$*" == *" -v"* && ! "$*" == *" --version"* ]]; then

    if [[ "$*" == *"maven.home"* ]]; then
        execute_java "Maven"
    elif [[ "$*" == *"GradleWorkerMain"* ]]; then
        execute_java "Gradle"
    else
        ${DIR}/java.bin "$@"
    fi
else
    ${DIR}/java.bin "$@"
fi
