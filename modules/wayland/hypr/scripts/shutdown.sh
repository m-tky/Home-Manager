#!/usr/bin/env zsh
read -p "Shut down now? (y/n): " answer

case "$answer" in
    [Yy]* )
        echo "Shutting down..."
        shutdown now
        ;;
    [Nn]* )
        echo "Canceled."
        sleep 0.7
        ;;
    * )
        echo "Invalid input. Use y or n."
        sleep 0.7
        ;;
esac
