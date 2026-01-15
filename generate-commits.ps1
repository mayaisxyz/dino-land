# PowerShell script to generate 2 years of backdated commits

Set-Location $PSScriptRoot

Write-Host "Configuring git..."
git config user.email "varis_mong@hotmail.com"
git config user.name "mayaisxyz"

# Initial commit
git add .
git commit -m "Initial commit"

Write-Host "Generating backdated commits for the past 2 years (730 days)..."

# Generate commits for past 730 days (2 years)
for ($daysAgo = 730; $daysAgo -ge 1; $daysAgo--) {
    # Skip about 30% of days randomly
    if ((Get-Random -Minimum 1 -Maximum 10) -le 3) {
        continue
    }

    # Random number of commits for this day (1-4)
    $numCommits = Get-Random -Minimum 1 -Maximum 5

    for ($commit = 1; $commit -le $numCommits; $commit++) {
        # Calculate the date for this commit
        $commitDate = (Get-Date).AddDays(-$daysAgo).ToString("yyyy-MM-dd HH:mm:ss")

        # Make a change to activity.log
        Add-Content -Path "activity.log" -Value "Update $commitDate"

        # Set environment variables for git
        $env:GIT_AUTHOR_DATE = $commitDate
        $env:GIT_COMMITTER_DATE = $commitDate

        # Commit with backdated timestamp
        git add activity.log
        git commit -m "Development update $(Get-Date (Get-Date).AddDays(-$daysAgo) -Format 'MMM dd, yyyy')" --quiet

        # Clear environment variables
        Remove-Item Env:\GIT_AUTHOR_DATE
        Remove-Item Env:\GIT_COMMITTER_DATE
    }

    # Show progress every 60 days
    if ($daysAgo % 60 -eq 0) {
        Write-Host "Generated commits up to $daysAgo days ago..."
    }
}

Write-Host "`nCommits generated successfully!"
Write-Host "`nTotal commits:"
git rev-list --count HEAD

Write-Host "`nRecent commits:"
git log --oneline -20
