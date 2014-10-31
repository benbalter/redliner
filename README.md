# Redliner

A tool for facilitating the redlining of documents with the GitHub uninitiated.

## How it works

1. You send the non-Github-user a unique, hashed URL
2. They edit the GitHub-hosted document
3. When they click submit, they unknowingly create a pull request

## Are users authenticated?

By default, the user is simply prompted to enter their name, so be sure to only share URLs with those you trust.

The user can also authenticate with their GitHub account, if they have one, which will create the pull request on their behalf, rather than using a bot account.

## How to generate a hashed URL

Swap `github.com` for your hosted Redliner instance in the URL to any file on GitHub.

You will be automatically redirect to the unique, hashed URL which you can then share with other, non-GitHub users.

## Running

This app is a simple Sinatra app. It's designed to run on Heroku, but can run anywhere. You'll need to configure the following environmental variables:

First, you'll need to create an oauth application, which is used to authenticate users with GitHub accounts. Once done, set these two environmental variables:

* `GITHUB_CLIENT_ID`
* `GITHUB_CLIENT_SECRET`

Next, you'll want to create a bot account, with personal access token scoped to the relevant repositories. It will need both read *and write* access. Once done, simply set the personal access token as:

* `GITHUB_TOKEN`

## Project status

Still in development. [There's a lot to be done](https://github.com/benbalter/redliner/issues), and we'd love your help.

## Contributing

1. Take a look at [the open issues](https:https://github.com/benbalter/redliner/issues).
2. Fork the project
3. Create a descriptively named feature branch
4. Tackle an open issue
5. Submit a pull request
