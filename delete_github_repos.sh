#!/bin/bash

: << 'COMMENT'
 I needed a quick and easy way of deleting Repos from my github. I like to have things organized as much as possible and when we are first getting started in programming it is easy to create lots of practice repos as we grow in our knowledge. Then when we have become comfortable enough with the process we look back and say to ourselves boy I should totally clean up my github repos directory. So I created this simple and easy to use script! Enjoy

#!!!! REQUIRED - GitHub CLI installed

If you have GitHub CLI installed all you have to do is:

open a terminal inside the directory where the bash script is located: OK

Run command <chmod +x (your-script-name)>: OK <This command simply allows your script to be executed> my script is named #?? delete_github_repos.sh

Run the command <gh auth login>: OK

Follow the steps to authenticate your instance of GitHub CLI: OK

Once you have successfully been authenticated: OK

Return to the terminal and run the script: OK 

So for my file I ran <./delete_github_repos.sh>

The script should intialize and return to you in the terminal all your repos on github in a numbered list. Great! The beauty of the CLI! Now all you need to do is to select the matching number to the repo you would like deleted and poof! Magic!

If you have any issues or concerns or questions feel free to reach out to me my email is <twowheeleddev@gmail> and I'll be happy to help you out! Thanks for taking the time to read my long winded directions enjoy the rest of your day 

COMMENT

# Check if gh CLI is authenticated
if ! gh auth status &>/dev/null; then
    echo "You need to authenticate with GitHub first."
    echo "Run: gh auth login"
    exit 1
fi

# Fetch the list of repositories
echo "Fetching your repositories..."
REPOS_JSON=$(gh repo list --limit 100 --json name --jq '.[].name')

# Convert the JSON output into an array
mapfile -t REPOS <<< "$REPOS_JSON"

# Display repositories in a numbered list
echo "Your repositories:"
for i in "${!REPOS[@]}"; do
    echo "$((i+1)). ${REPOS[$i]}"
done

# Ask user for repositories to delete
read -p "Enter the matching number of the repository you want to delete. Multiple Repos can be selected for deletion by seperating each entry with a COMMA (,): " INPUT

# Convert input into an array
IFS=',' read -ra SELECTION <<< "$INPUT"

# Confirm before deletion
echo "You have selected the following repositories for deletion:"
for i in "${SELECTION[@]}"; do
    INDEX=$((i-1))
    if [[ $INDEX -ge 0 && $INDEX -lt ${#REPOS[@]} ]]; then
        echo "- ${REPOS[$INDEX]}"
    else
        echo "Invalid selection: $i"
    fi
done

read -p "Are you sure you want to delete these repositories? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Delete selected repositories
for i in "${SELECTION[@]}"; do
    INDEX=$((i-1))
    if [[ $INDEX -ge 0 && $INDEX -lt ${#REPOS[@]} ]]; then
        REPO_NAME="${REPOS[$INDEX]}"
        echo "Deleting $REPO_NAME..."
        gh repo delete "$REPO_NAME" --yes
    fi
done

echo "Operation completed."
