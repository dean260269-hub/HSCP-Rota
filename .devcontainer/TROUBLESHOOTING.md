# Codespaces Billing Error Troubleshooting Guide

If you're seeing the message: **"You seem to have a billing issue. Please adjust your billing settings to continue using codespaces."** even though your billing is in good standing, this guide will help you resolve it.

## Important: This is Usually NOT a Devcontainer Issue

The billing error message is **almost never** caused by the devcontainer configuration. It's a GitHub account or quota issue. The devcontainer configuration in this repository is valid and optimized.

## Common Causes and Solutions

### 1. Monthly Quota Exceeded (Most Common)

GitHub provides free Codespaces usage each month, but it's limited:

- **Free Plan**: 120 core-hours/month + 15 GB storage
- **Pro Plan**: 180 core-hours/month + 20 GB storage
- **Student Developer Pack**: 180 core-hours/month + 20 GB storage

**How to Check:**
1. Go to https://github.com/settings/billing/summary
2. Look at "Codespaces" usage for the current month
3. If you've exceeded your quota, you'll see the billing error

**Solutions:**
- Wait until the 1st of next month when your quota resets
- Add a payment method and set a spending limit to continue immediately
- Delete unused codespaces to free up storage quota

### 2. Spending Limit Set to $0

Even if you have a payment method on file, GitHub won't charge you unless you explicitly allow it.

**How to Fix:**
1. Go to https://github.com/settings/billing/spending_limit
2. Find the "Codespaces" section
3. Check if "Spending limit" is set to "$0"
4. Either:
   - Set a reasonable limit (e.g., $10/month)
   - OR select "Unlimited" if you want no cap
5. Make sure "Pause usage when limit is reached" is set according to your preference

### 3. No Payment Method (For Usage Beyond Free Tier)

If you want to use Codespaces beyond the free tier, you need a payment method.

**How to Fix:**
1. Go to https://github.com/settings/billing/payment_information
2. Add a valid credit/debit card
3. Go back to spending limits and set a reasonable limit for Codespaces
4. Try creating your codespace again

### 4. Organization Quota Issues

If this repository belongs to an organization, the organization's quota might have been exceeded.

**How to Fix:**
1. Contact your organization administrator
2. The administrator needs to check the organization's billing settings at the org level
3. The organization may need to increase its Codespaces spending limit

### 5. Stale Browser/Authentication State

Sometimes the error message persists even after fixing billing issues due to cached state.

**How to Fix:**
1. Log out of GitHub completely
2. Clear your browser cache and cookies
3. Log back in
4. Try creating a codespace again

### 6. Old Codespaces Not Deleted

Stopped codespaces still count toward your storage quota until fully deleted.

**How to Fix:**
1. Go to https://github.com/codespaces
2. Look for any old codespaces from this or other repositories
3. Delete them completely (don't just stop them)
4. Wait a few minutes for the quota to update
5. Try creating a new codespace

## Verification Checklist

Before contacting support, verify:

- [ ] You haven't exceeded your monthly core-hour quota
- [ ] You haven't exceeded your storage quota
- [ ] Your Codespaces spending limit is NOT set to $0
- [ ] You have a valid payment method (if using beyond free tier)
- [ ] You've deleted all old/unused codespaces
- [ ] You've logged out and back in to refresh your session
- [ ] The repository isn't in an organization with billing issues

## Still Having Issues?

If you've verified all of the above and still see the billing error:

1. **Double-check your billing settings** at https://github.com/settings/billing
2. **Wait 10-15 minutes** after making billing changes for them to propagate
3. **Try from a different browser** or incognito mode
4. **Contact GitHub Support** through your GitHub account settings or at https://support.github.com/request with:
   - Your GitHub username
   - The exact error message
   - Screenshots of your billing settings showing valid payment info
   - Confirmation that you're under your quota limits

## This Repository's Devcontainer Configuration

For reference, this repository uses:
- **Base Image**: `mcr.microsoft.com/devcontainers/base:ubuntu` (lightweight, reliable)
- **MySQL Feature**: Official devcontainers feature for MySQL
- **Machine Size**: Uses the default 2-core machine

This configuration is minimal and optimized to reduce resource usage and avoid triggering quota issues unnecessarily.

## Additional Resources

- [GitHub Codespaces Billing Documentation](https://docs.github.com/en/billing/managing-billing-for-github-codespaces)
- [GitHub Codespaces Quotas](https://docs.github.com/en/codespaces/overview#codespaces-usage-quotas)
- [Managing Spending Limits](https://docs.github.com/en/billing/managing-billing-for-github-codespaces/managing-spending-limits-for-codespaces)
