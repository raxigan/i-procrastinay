#!/bin/zsh

OS="$(uname -s)"
DIR=$(dirname "$0")

if [[ "$OS" == "Linux"* ]]; then
    if ! command -v notify-send &> /dev/null ; then
        echo "notify-send not installed or not on system path, terminating..."
        exit 1
    fi
elif [[ "$OS" == "Darwin"* ]]; then
    if ! command -v terminal-notifier &> /dev/null ; then
        echo "terminal-notifier not installed or not on system path, terminating..."
        exit 1
    fi
else
    echo "Unknown operating system, terminating..."
    exit 1
fi

use_local_or_download() {
    SCRIPT=$1

    if test -f "${DIR}/${SCRIPT}"; then
        cat ${DIR}/${SCRIPT} > ${ORIGINAL_EXECUTABLE}
    else
        curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/${SCRIPT} > ${ORIGINAL_EXECUTABLE}
    fi

    if test -f "${DIR}/wrapper.sh"; then
        echo "- Using local wrapper script..."
        cat ${DIR}/wrapper.sh >> ${ORIGINAL_EXECUTABLE}
    else
        echo "- Downloading wrapper script..."
        curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/wrapper.sh >> ${ORIGINAL_EXECUTABLE}
    fi
}

prepare_wrapper_script() {
    if [[ "$OS" == "Linux"* ]]; then
        use_local_or_download "notify_linux.sh"
    else
        use_local_or_download "notify_macos.sh"
    fi
}

install_for_runtime() {

    NEW_EXECUTABLE=${JAVA_RUNTIME}/bin/java.bin
    ORIGINAL_EXECUTABLE=${JAVA_RUNTIME}/bin/java

    echo "Installing for Java runtime: ${JAVA_RUNTIME}"

    if test -f "${NEW_EXECUTABLE}"; then
        # Update
        echo "- Found wrapper script. Updating it... "
        prepare_wrapper_script
    else
        # Install
        if test -f "${ORIGINAL_EXECUTABLE}"; then

            type=`file ${ORIGINAL_EXECUTABLE}`

            if [[ ! "${type}" == "text"* ]]; then
                mv ${ORIGINAL_EXECUTABLE} "${NEW_EXECUTABLE}"
                echo "- Creating wrapper script... "
                prepare_wrapper_script
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
        install_for_runtime
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
                install_for_runtime
            fi
        done

    else

        echo "Custom Java runtime paths provided."

        for path in "$@"; do
            JAVA_RUNTIME=$path
            install_for_runtime
        done
    fi
fi

echo "Installation completed."
