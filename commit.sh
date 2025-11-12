#!/bin/bash

# Go to your project folder
cd /home/mark/Zynamis/auto-dir || exit

# Ensure activity tracking files exist
touch .git-activity.txt
touch .last_commit.txt

# Read last commit timestamp (seconds since epoch)
if [ -s .last_commit.txt ]; then
    last_commit=$(cat .last_commit.txt)
else
    last_commit=0
fi

# Current timestamp in seconds
current_time=$(date +%s)

# Interval in seconds (15 minutes = 900 seconds)
interval=900

# Calculate how many commits were "missed"
diff=$((current_time - last_commit))
missed=$((diff / interval))

# Loop to create commits for missed intervals
for ((i=0; i<missed; i++)); do
    # Pick a random second offset within the 15-minute interval
    random_offset=$((RANDOM % interval))
    commit_time=$((last_commit + random_offset))

    # Format random timestamp for the commit message
    formatted_time=$(date -d @"$commit_time" '+%Y-%m-%d %H:%M:%S')

    # Update activity file
    echo "Last activity: $formatted_time" >> .git-activity.txt

    # Stage and commit
    git add .git-activity.txt
    git commit -m "Auto commit $formatted_time"
done

# Push all new commits at once
git push origin main

# Update last commit timestamp
echo $current_time > .last_commit.txt
