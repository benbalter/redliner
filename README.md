# Redliner

A tool for facilitating the redlining of documents with the GitHub uninitiated.

## How it works

1. You send the non-Github-user a unique, hashed URL
2. They are prompted to edit a GitHub-hosted document
3. Upon submission, they unknowingly create a pull request

## Are users authenticated?

By default, the user is simply prompted to enter their name, so be sure to only share URLs with those you trust.

The user can also authenticate with their GitHub account, which will create the pull request on their behalf, rather than using a bot account.

## How to generate a hashed URL

Swap `github.com` for your hosted instance in the URL to any file on GitHub.

You will be automatically redirect to the unique, hashed URL which you can then share with other, non-GitHub users.

## Running

This app is a simple Sinatra app. It's designed to run on Heroku, but can run anywhere. You'll need to configure the following environmental variables:

* `GITHUB_CLIENT_ID`
* `GITHUB_CLIENT_SECRET`
* `GITHUB_TOKEN`

## Project status

Still in development. Not for production use. 
