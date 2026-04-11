#!/bin/bash

# Configuration with defaults
EXPECTED_SECONDS=${1:-100}
MAX_POLLS=${2:-10}
BRIDGE_URL=${3:-"http://127.0.0.1:3457"}

# Calculate interval
INTERVAL=$((EXPECTED_SECONDS / MAX_POLLS))
if [ $INTERVAL -lt 1 ]; then
    INTERVAL=1
fi

echo "Polling Roo Bridge at $BRIDGE_URL (Interval: ${INTERVAL}s, Max Polls: $MAX_POLLS)"

for ((i=1; i<=MAX_POLLS; i++))
do
    # Use curl to get the status. -s for silent.
    RESPONSE=$(curl -s "$BRIDGE_URL/status")
    
    echo "Poll $i: $RESPONSE"
    
    # Check if response contains "done" or "error"
    if [[ "$RESPONSE" == *"\"done\""* ]] || [[ "$RESPONSE" == *"\"error\""* ]]; then
        break
    fi
    
    sleep $INTERVAL
done

echo "$RESPONSE"
