# Rails Static Router [![Build Status](https://travis-ci.org/mufid/rails-static-router.svg?branch=master)](https://travis-ci.org/mufid/rails-static-router) [![Gem Version](https://badge.fury.io/rb/rails-static-router.svg)](https://badge.fury.io/rb/rails-static-router)

Enjoy static routes in your Rails `config/routes.rb`.

<!-- MarkdownTOC depth=0 autolink=true bracket=round -->

- [Installation](#installation)
- [Example use](#example-use)
- [Why?](#why)
- [Contributors](#contributors)

<!-- /MarkdownTOC -->

## Installation

1. Put `gem 'rails-static-router'` in your `Gemfile`
2. Restart app

## Example use

```ruby
Rails.application.routes.draw do
  ...
  # This route will serve public/index.html at the /login URL path, and have
  # URL helper named `login_path`:
  get "/login", to: static("index.html")

  # This route will serve public/index.html at the /register URL path, and
  # have URL helper named `new_user_registration_path`:
  get "/register", to: static("index.html"), as: :new_user_registration
  ...
end
```

`bin/rake routes` output for the above routes:

```
               Prefix  Verb  URI Pattern          Controller#Action
                login  GET   /login(.:format)     static('index.html')
new_user_registration  GET   /register(.:format)  static('index.html')
```
 
## Compatibility

This gem is compatible with Rails 4.1+.

## Why?

This introduces a `static(path_to_file)` helper method to route to static files
from within `routes.rb`. It is inspired by Rails' existing `redirect(...)` method.

Some benefits of this technique over alternatives (such as rack-rewrite,
nginx/httpd-configured rewrites):

- Named URL helper method for static file available throughout app, for
  example in mail templates, view templates, and tests.

- Route discoverable via `bin/rake routes` and Routing Error page in development.

- Takes advantage of ActionDispatch's built-in gzip handling. Controller action
  based solutions for rendering static files tend to not use this.

- Handy for Single Page Apps that serve the same static HTML file for multiple
  paths, as is often the case with Ember & Angular apps.

- Heroku-like production environments work with this that do use the Rails app
  to serve static files.

- Leaves door open for nginx, Apache, Varnish and friends to serve the static
  files directly for improved performance in production environments via symlinks
  and/or other artifacts generated at deploy time.

## Contributors

- Eliot Sykes https://eliotsykes.com/
- Muhammad Mufid Afif https://mufid.github.io
- Your name here! Contributions are welcome and easy. Fork the GitHub repo, make your changes, then submit your pull request. Don't hesitate to ask if you'd like some help.

## Contributing

We are using Appraisals to test against multiple Rails version. To set it
up for the first time, please run:

    bundle install
    bundle exec appraisal install

After Appraisal installed, use this command to run all the test:

    bundle exec appraisal rake test

To run against only specific Rails version, you can specify it
with `BUNDLE_GEMFILE`. For example, if you want to run only
against Rails 5.2, you can execute command below.

    export BUNDLE_GEMFILE=gemfiles/rails51.gemfile
    bundle install
    bundle exec rake test

To test it agains multiple Ruby version, you may want to use rvm.
For example:

    # Test it against all specified Rails version
    # with Ruby version 2.3.7
    rvm install 2.3.7
    rvm use 2.3.7
    bundle exec appraisal rake test

    # Test it against all specified Rails version
    # with Ruby version 2.4.4
    rvm install 2.4.4
    bundle exec appraisal rake test

## Releasing

For contributors that have access to release server, do the
following commands to release the gem.

    # Edit version.rb to match next version, then
    git add .
    git commit -m "ops: <NEXT_VERSION> release"
    bundle exec rake release
