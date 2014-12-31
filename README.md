# Redliner

A tool for facilitating the redlining of documents by the GitHub uninitiated.

![screenshot](https://cloud.githubusercontent.com/assets/282759/4864720/931fdd14-611e-11e4-9d17-927cc5b20704.png)

## How it works

1. You give the editor a unique, hashed URL
2. They edit the GitHub-hosted document, either semi-anonymously or authenticated through Github
3. When they click submit, Redliner automatically creates a pull request on their behalf

## Are users authenticated?

By default, the user is simply prompted to enter their name, so be sure to only share URLs with those you trust.

The user can also authenticate with their GitHub account, if they have one, which will create the pull request on their behalf, rather than using a bot account.

## How to generate a hashed URL

Swap `github.com` for your hosted Redliner instance in the URL to any file on GitHub.

You will be automatically redirect to the unique, hashed URL which you can then share with other, non-GitHub users.

## Running

This app is a simple Sinatra app. It's designed to run on Heroku, but can run anywhere.

First, you'll need to create a [developer application](https://github.com/settings/applications), which is used to authenticate users with GitHub accounts. The callback URL for authentication is simply the root URL. Once done, set these two environmental variables:

* `GITHUB_CLIENT_ID`
* `GITHUB_CLIENT_SECRET`

Next, you'll want to create a bot account with a [personal access token](https://github.com/settings/applications) scoped to the relevant repositories. It will need both read *and write* access. Once done, simply set the personal access token as:

* `GITHUB_TOKEN`

You'll also need a Redis database. The free level of any of the [Heroku addons](https://addons.heroku.com/#data-stores) should work, but Redistogo will work out of the box. Just run

`heroku addons:add redistogo`

If you want to use a different provider, just make sure that the database's URL is set as `REDIS_URL`.

## Project status

Still in development. [There's a lot to be done](https://github.com/benbalter/redliner/issues), and we'd love your help.

## Contributing

### Flow


1. Take a look at [the open issues](https:https://github.com/benbalter/redliner/issues).
2. Fork the repository
3. Create a descriptively named feature branch
4. Tackle an open issue
5. Submit a pull request

### Working Locally

Install your fork of Redliner locally:

```
git clone git@github.com:your-name/redliner.git
cd redliner
bundle install
touch .env
git checkout -b descriptive-branch-name
```
Set your local variables for `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`, and `GITHUB_TOKEN` in `.env`. You'll probably want to create a separate Github application for this, as you'll need to set `localhost:5000` as the callback URL.

Then, start up a local Redis server (you may need to install Redis):
```
redis-server --port 16379
```
Start the app:
```
foreman start
```
