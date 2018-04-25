# Rack Domain Filter

## Prerequisites

- Ruby 2.1+

## Installation

Put this into `Gemfile`:

    gem 'rack-domain-filter'

Then run `bundle`.

## Builder API

See Yarddoc for more information.

## Usage

Suppose you have `Company` model. In Rails, you can do
like this:

    # Put this inside application.rb, or
    # any environment file in config/environments/*.rb

    Rack::DomainFilter.configure do |config|
      config.filter_for /(.+).local.dev/ do |slug|
        Thread.current[:company] = Company.find_by!(slug)
      end

      config.filter_for /(.+).peentar.id/ do |slug|
        Thread.current[:company] = Company.find_by!(slug)
      end

      config.filter_for /tenant-onpremise.ourclients.com/ do
        Thread.current[:company] = Company.find_by!(slug: 'tenant-onpremise.ourclients.com')
      end

      config.catch ActiveRecord::NotFound do
        [404, {}, "Not Found"]
      end

      config.no_match do
        [404, {}, "No slug found"]
      end

      config.after_request do
        Thread.current[:company] = nil
      end
    end

    config.middleware.use Rack::DomainFilter

In your controller, you can get your current company with
this syntax:

    class ApplicationController < ActionController::Base
      def current_company
        Thread.current[:company]
      end
    end

    def ApplicationHelper
      def current_company
        Thread.current[:company]
      end
    end

You may want to put this into global filter. This
is quick but dirty solution.

    class ApplicationRecord < ActiveRecord::Base
      default_scope do
        if Thread.current[:company]
          where(company_id: Thread.current[:company].id)
        else
          nil
        end
      end
    end

The best way to use this is to explictly
ask Model to search in current company scope

    class ApplicationRecord < ActiveRecord::Base
      scope :in_current_company, -> { where(company: Thread.current[:company]) }
    end

    class Manager < ApplicationRecord; end

    @managers = Manager.in_current_company
