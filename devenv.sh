#!/bin/bash

COMMAND=${$1,,};

case $COMMAND in

  "make" | "new" | "init")
    
    ;;

  "import")
    STATEMENTS
    ;;

  "add" | "install" | "i")
    STATEMENTS
    ;;

  "remove" | "rm" | "uninstall" | "u" | "r")
    STATEMENTS
    ;;

  *)
    STATEMENTS
    ;;
esac
