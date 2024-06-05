# Check if .git directory exists
$gitInitialized = Test-Path -Path ".git" -PathType Container

if (-not $gitInitialized) { # -not $gitInitialized is a comparison. It checks if $gitInitialized is not true. If $gitInitialized is $false or $null
    # Git is not initialized, perform git init
    git init
}

# Check if remote 'origin' already exists | REPLACE the URL with the working project repository
$remoteExists = git remote get-url origin 2>$null

if (-not $remoteExists) {
    # Remote 'origin' does not exist, add it
    git remote add origin https://github.com/RScrafted/terraform-azure-vm-automation # ATTENTION!
}

# Add files and commit changes
git add .
$commitMessage = Read-Host -Prompt 'Enter commit message' # prompts user input. add #AsSecureString will mask in realtime
git commit -m "$commitMessage"

# Push changes to remote 'origin'
git push