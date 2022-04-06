#!/bin/zsh

uname="$(uname -s)"

if [[ "$uname" == "Linux"* ]]; then
    if ! command -v notify-send &> /dev/null ; then
        echo "notify-send not installed or not on system path, terminating..."
        exit 1
    fi
elif [[ "$uname" == "Darwin"* ]]; then
    if ! command -v terminal-notifier &> /dev/null ; then
        echo "terminal-notifier not installed or not on system path, terminating..."
        exit 1
    fi
else
    echo "Unknown operating system, terminating..."
    exit 1
fi

wrap_java_runtime() {

    NEW_EXECUTABLE=${JAVA_RUNTIME}/bin/java.bin
    ORIGINAL_EXECUTABLE=${JAVA_RUNTIME}/bin/java

    echo "Installing for Java runtime: ${JAVA_RUNTIME}"

    if test -f "${NEW_EXECUTABLE}"; then
        # Update
        echo "- Found wrapper script. Updating it... "

        if [[ "$uname" == "Linux"* ]]; then
            curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/notify_linux.sh > ${ORIGINAL_EXECUTABLE}
        else
            curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/notify_macos.sh > ${ORIGINAL_EXECUTABLE}
        fi
        curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/wrapper.sh >> ${ORIGINAL_EXECUTABLE}
    else
        # Install
        if test -f "${ORIGINAL_EXECUTABLE}"; then

            type=`file ${ORIGINAL_EXECUTABLE}`

            if [[ ! "${type}" == "text"* ]]; then
                mv ${ORIGINAL_EXECUTABLE} "${NEW_EXECUTABLE}"
                echo "- Creating wrapper script... "

                if [[ "$uname" == "Linux"* ]]; then
                    curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/notify_linux.sh > ${ORIGINAL_EXECUTABLE}
                else
                    curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/notify_macos.sh > ${ORIGINAL_EXECUTABLE}
                fi
                curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/wrapper.sh >> ${ORIGINAL_EXECUTABLE}

                chmod u+x ${ORIGINAL_EXECUTABLE}
            else
                echo "- 'java' file is not executable, skipping installation for this runtime"
            fi
        else
            echo "- Java binary not found under path ${ORIGINAL_EXECUTABLE}"
        fi
    fi
}


if [ $# -eq 0 ]; then
    
    echo "Simple mode enabled"

    if [[ ! -z "${JAVA_HOME}" ]]; then
        JAVA_RUNTIME=$JAVA_HOME
        wrap_java_runtime
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
                wrap_java_runtime
            fi
        done

    else

        echo "Custom Java runtime paths provided."

        for path in "$@"; do
            JAVA_RUNTIME=$path
            wrap_java_runtime
        done
    fi
fi

echo "Installation completed."
