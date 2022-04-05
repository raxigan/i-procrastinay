#!/bin/zsh

if ! command -v terminal-notifier &> /dev/null
then
    echo "terminal-notifier not installed or not on system path, terminating..."
    exit 1
fi

wrap_java_runtime() {

    NEW_EXECUTABLE=${JAVA_RUNTIME}/bin/java.bin
    ORIGINAL_EXECUTABLE=${JAVA_RUNTIME}/bin/java

    echo "Wrapping Java runtime: ${JAVA_RUNTIME}"

    # Update
    if test -f "${NEW_EXECUTABLE}"; then
        echo "Found wrapper script. Updating it... "
        curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/wrapper.sh >> ${ORIGINAL_EXECUTABLE}
        echo "Update completed."
        exit 0
    fi

    # Install
    if test -f "${ORIGINAL_EXECUTABLE}"; then
        echo "Java binary found. Renaming it to ${NEW_EXECUTABLE}"
        mv ${ORIGINAL_EXECUTABLE} "${NEW_EXECUTABLE}"
    else
        echo "Java binary not found under path ${ORIGINAL_EXECUTABLE}, terminating..."
        exit 1
    fi

    echo "Wrapping Java executable..."
    curl -s https://raw.githubusercontent.com/raxigan/i-procrastinay/main/wrapper.sh >> ${ORIGINAL_EXECUTABLE}
    echo "Assigning permissions..."
    chmod u+x ${ORIGINAL_EXECUTABLE}

    echo "Installation completed."
    exit 0
}


if [ $# -eq 0 ]; then
    
    echo "No Java runtime paths provided, looking for JAVA_HOME..."

    if [[ ! -z "${JAVA_HOME}" ]]; then
        JAVA_RUNTIME=$JAVA_HOME
        wrap_java_runtime
    else
        echo "JAVA_HOME not set, terminating..."
    fi

else

    echo "Custom Java runtime paths provided."

    for path in "$@"; do
        JAVA_RUNTIME=$path
        wrap_java_runtime
    done
fi
