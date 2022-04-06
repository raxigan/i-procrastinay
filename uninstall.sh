#!/bin/zsh

unwrap_java_runtime() {

    NEW_EXECUTABLE=${JAVA_RUNTIME}/bin/java.bin
    ORIGINAL_EXECUTABLE=${JAVA_RUNTIME}/bin/java

    echo "Uninstalling for Java runtime: ${JAVA_RUNTIME}"

    if test -f "${NEW_EXECUTABLE}"; then
        mv ${NEW_EXECUTABLE} "${ORIGINAL_EXECUTABLE}"
        echo "- Uninstalled"
    else
        echo "- Installation was not found"
    fi
}


if [ $# -eq 0 ]; then
    
    echo "Simple mode enabled"

    if [[ ! -z "${JAVA_HOME}" ]]; then
        JAVA_RUNTIME=$JAVA_HOME
        unwrap_java_runtime
    else
        echo "JAVA_HOME not set, terminating..."
    fi

else

    if [[ ! "$*" == *" --sdkman"* ]]; then

        echo "SDKMAN mode enabled"

        SDKMAN_ROOT=~/.sdkman/candidates/java

        for dir in ${SDKMAN_ROOT}/*/ ; do

            if [[ ! "${dir}" == "${SDKMAN_ROOT}/current/" ]]; then
                JAVA_RUNTIME=$dir
                unwrap_java_runtime
            fi
        done

    else

        echo "Custom Java runtime paths provided."

        for path in "$@"; do
            JAVA_RUNTIME=$path
            unwrap_java_runtime
        done
    fi
fi

echo "Uninstallation completed."
