#!/bin/bash

# Git wrapper script that handles SSH authentication failures with Bitwarden

# Store the git command arguments
GIT_COMMAND="$@"

# Run the original git command
git "$@"
EXIT_CODE=$?

# Check if the command failed with SSH authentication error
if [ $EXIT_CODE -ne 0 ]; then
    # Capture the last few lines of git output to check for auth errors
    ERROR_OUTPUT=$(git "$@" 2>&1)
    
    if echo "$ERROR_OUTPUT" | grep -q "Permission denied (publickey)\|Could not read from remote repository"; then
        echo ""
        echo "🔐 SSH authentication failed. Opening Bitwarden to unlock SSH agent..."
        echo ""
        
        # Open Bitwarden (this will launch the app)
        open -a "Bitwarden"
        
        # Wait a moment for Bitwarden to open
        sleep 2
        
        echo "Please unlock Bitwarden to enable SSH agent access."
        echo ""
        read -p "Press Enter once Bitwarden is unlocked to retry the git command..."
        
        # Retry the git command
        echo ""
        echo "Retrying: git $GIT_COMMAND"
        git "$@"
        EXIT_CODE=$?
    fi
fi

exit $EXIT_CODE
