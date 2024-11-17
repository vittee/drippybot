#!/bin/bash

start_cupsd() {
    if ! pgrep -x "cupsd" > /dev/null; then
        cupsd
    fi
}

err() {
    echo -e >&2 "$@"
    exit 1
}

model() {
    start_cupsd
    lpinfo -m | fzf --tac --layout=reverse --with-nth 2.. --bind 'enter:become(echo {1})'
}

print() {
    if [ -z ${URI+_} ]; then
        err No printer URI is specified
    fi

    if [ -z ${MODEL+_} ]; then
        err "No printer MODEL is specified\nTry running with \"model\" argument to select a supported model"
    fi

    start_cupsd

    # Add the printer
    lpadmin -p default -v "$URI" -m "$MODEL"
    # Enable and accept print job
    cupsaccept default
    cupsenable default
    # Set as a default printer
    lpoptions -d default
    # Send the print job
    lp /usr/share/cups/data/testprint
    # wait
    sleep ${WAIT:-5}
}

ulimit -n 65536

case "$1" in
    model)
        model
        ;;

    bash)
        bash
        ;;

    print)
        print
        ;;

    *)
        sleep infinity
        ;;
esac
