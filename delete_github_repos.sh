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

The script should initialize and return to you in the terminal all your repos on github in a numbered list. Great! The beauty of the CLI! Now all you need to do is to select the matching number to the repo you would like deleted and poof! Magic!

If you have any issues or concerns or questions feel free to reach out to me my email is <twowheeleddev@gmail.com> and I'll be happy to help you out! Thanks for taking the time to read my long winded directions enjoy the rest of your day 

COMMENT

# ============================================================================
# Configuration Variables
# ============================================================================

# Maximum number of repositories to fetch (adjust as needed)
readonly REPO_LIMIT=100

# Color codes for better terminal output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# ============================================================================
# Utility Functions
# ============================================================================

# @dev Print error message in red and exit
# @param $1 Error message to display
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

# @dev Print success message in green
# @param $1 Success message to display
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# @dev Print warning message in yellow
# @param $1 Warning message to display
print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

# @dev Print info message in blue
# @param $1 Info message to display
print_info() {
    echo -e "${BLUE}$1${NC}"
}

# @dev Validate that input is numeric
# @param $1 Input string to validate
# @return 0 if numeric, 1 otherwise
is_numeric() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# ============================================================================
# Main Script Logic
# ============================================================================

# @dev Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# @dev Check if user is authenticated with GitHub CLI
if ! gh auth status &>/dev/null; then
    print_error "You need to authenticate with GitHub first."
    echo "Run: gh auth login"
    exit 1
fi

# @dev Get the authenticated GitHub username for full repository paths
print_info "Getting authenticated user information..."
USERNAME=$(gh api user --jq '.login' 2>/dev/null)
if [[ -z "$USERNAME" ]]; then
    print_error "Failed to get authenticated username."
    exit 1
fi

print_success "Authenticated as: $USERNAME"
echo

# @dev Fetch the list of repositories from GitHub
print_info "Fetching your repositories (limit: $REPO_LIMIT)..."
REPOS_JSON=$(gh repo list --limit "$REPO_LIMIT" --json name --jq '.[].name' 2>&1)

# @dev Check if the fetch operation was successful
if [[ $? -ne 0 ]]; then
    print_error "Failed to fetch repositories."
    echo "$REPOS_JSON"
    exit 1
fi

# @dev Convert the JSON output into a bash array
mapfile -t REPOS <<< "$REPOS_JSON"

# @dev Check if the repositories array is empty
if [[ ${#REPOS[@]} -eq 0 ]] || [[ -z "${REPOS[0]}" ]]; then
    print_warning "No repositories found for user: $USERNAME"
    exit 0
fi

# @dev Display repositories in a numbered list for user selection
echo
print_info "Your repositories (${#REPOS[@]} found):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for i in "${!REPOS[@]}"; do
    echo "$((i+1)). ${REPOS[$i]}"
done
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# @dev Prompt user for repository selection (supports multiple selections)
read -p "Enter the number(s) of the repository/repositories to delete. Multiple repos can be selected by separating each entry with a COMMA (,): " INPUT

# @dev Validate that input is not empty
if [[ -z "$INPUT" ]]; then
    print_warning "No input provided. Operation cancelled."
    exit 0
fi

# @dev Convert comma-separated input into an array, trimming whitespace
IFS=',' read -ra SELECTION <<< "$INPUT"

# @dev Validate selections and build list of valid repositories to delete
declare -a VALID_REPOS
declare -a INVALID_SELECTIONS

for i in "${SELECTION[@]}"; do
    # Trim whitespace from selection
    i=$(echo "$i" | xargs)
    
    # Check if selection is numeric
    if ! is_numeric "$i"; then
        INVALID_SELECTIONS+=("$i (not a number)")
        continue
    fi
    
    # Convert to array index (1-based to 0-based)
    INDEX=$((i-1))
    
    # Validate index is within bounds
    if [[ $INDEX -ge 0 && $INDEX -lt ${#REPOS[@]} ]]; then
        VALID_REPOS+=("${REPOS[$INDEX]}")
    else
        INVALID_SELECTIONS+=("$i (out of range)")
    fi
done

# @dev Display any invalid selections to the user
if [[ ${#INVALID_SELECTIONS[@]} -gt 0 ]]; then
    echo
    print_warning "Invalid selections found:"
    for invalid in "${INVALID_SELECTIONS[@]}"; do
        echo "  - $invalid"
    done
fi

# @dev Check if there are any valid repositories to delete
if [[ ${#VALID_REPOS[@]} -eq 0 ]]; then
    print_error "No valid repositories selected. Operation cancelled."
    exit 1
fi

# @dev Display selected repositories for user confirmation
echo
print_warning "You have selected the following ${#VALID_REPOS[@]} repository/repositories for deletion:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for repo in "${VALID_REPOS[@]}"; do
    echo "  - $USERNAME/$repo"
done
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# @dev Final confirmation before deletion (destructive operation)
read -p "⚠️  Are you ABSOLUTELY SURE you want to delete these repositories? This cannot be undone! (y/N): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    print_info "Operation cancelled by user."
    exit 0
fi

echo

# @dev Delete each selected repository with error handling
DELETED_COUNT=0
FAILED_COUNT=0

for repo in "${VALID_REPOS[@]}"; do
    FULL_REPO_NAME="$USERNAME/$repo"
    print_info "Deleting repository: $FULL_REPO_NAME..."
    
    # Attempt to delete the repository
    if gh repo delete "$FULL_REPO_NAME" --yes 2>&1; then
        print_success "✓ Successfully deleted: $repo"
        ((DELETED_COUNT++))
    else
        print_error "✗ Failed to delete: $repo"
        ((FAILED_COUNT++))
    fi
    echo
done

# @dev Display operation summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "Operation completed!"
echo "  Deleted: $DELETED_COUNT"
if [[ $FAILED_COUNT -gt 0 ]]; then
    echo "  Failed:  $FAILED_COUNT"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
