# GitHub Repository Deletion Script

A simple and effective bash script for batch-deleting GitHub repositories using the GitHub CLI.

## Features

- ✅ Interactive repository selection with numbered list
- ✅ Support for multiple repository deletion in one run
- ✅ Input validation and error handling
- ✅ Color-coded terminal output for better UX
- ✅ Safety confirmation before deletion
- ✅ Comprehensive error reporting
- ✅ Full username/path support

## Prerequisites

- **GitHub CLI (gh)** must be installed
  - Installation: https://cli.github.com/
- Authenticated GitHub CLI session

## Installation

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x delete_github_repos.sh
   ```

## Usage

1. Authenticate with GitHub CLI (if not already done):
   ```bash
   gh auth login
   ```

2. Run the script:
   ```bash
   ./delete_github_repos.sh
   ```

3. Follow the interactive prompts:
   - View your repositories in a numbered list
   - Enter the number(s) of repositories to delete (comma-separated for multiple)
   - Confirm the deletion

## Example

```bash
$ ./delete_github_repos.sh

Your repositories (15 found):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. test-repo-1
2. old-project
3. practice-code
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Enter the number(s) of the repository/repositories to delete. Multiple repos can be selected by separating each entry with a COMMA (,): 2,3

You have selected the following 2 repository/repositories for deletion:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  - username/old-project
  - username/practice-code
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Are you ABSOLUTELY SURE you want to delete these repositories? This cannot be undone! (y/N): y
```

## Improvements in Latest Version

- Added comprehensive developer comments throughout the code
- Implemented color-coded output for better visibility
- Added input validation (numeric checks, bounds checking)
- Improved error handling with descriptive messages
- Added GitHub username detection and full repo path support
- Better whitespace handling in user input
- Added operation summary with success/failure counts
- Fixed typos in documentation
- Added check for empty repository list
- Modular code structure with utility functions

## Support

For issues, questions, or suggestions, contact: twowheeleddev@gmail.com

## License

Free to use and modify. Enjoy!
