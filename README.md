# CouchRest-Rails

A Rails plugin for connecting to and working with a [CouchDB](http://couchdb.apache.org) document-oriented database via the [CouchRest](http://github.com/jchris/couchrest) RESTful CouchDB client.

Specifically, this plugin provides the following utilities:

* Initializer for use with a couchdb.yml configuration file
* CouchDB-specific rake tasks
* CouchDB-specific fixtures
* Setup and teardown helpers for spec'ing and testing

This plugin currently assumes your application only uses one CouchDB database.  It does not interfere with the traditional relational database backend, so you can use that as a datastore alongside CouchDB if you want.  (In fact, you'll have to unwire the requirement for a relational database if you don't want to use one.)

## Requirements

* [CouchRest gem](http://github.com/jchris/couchrest)
* [couchapp](http://github.com/djchris/couchrest) There is a Ruby and Python version of this application. Currently, the Python version is winning.
* [RSpec](http://github.com/dchelimsky/rspec) BDD framework (optional - for running plugin specs)
* [RSpec-Rails](http://github.com/dchelimsky/rspec-rails) library (optional - for running plugin specs)


## Installation and usage

Install with the native Rails plugin installation script:

    script/plugin install git://github.com/hpoydar/couchrest-rails.git

Or simply add to vendor/plugins and generate the files you need:

    script/generate couchrest_rails relax
    
The plugin creates two folders:

* `db/couch/fixtures` - for storing CouchDB fixtures (yaml)
* `db/couch/views` - for storing CouchDB map and reduce functions

These paths can be customized in an initializer or environment configuration file:

    CouchrestRails.fixtures_path  = 'custom/path/to/your/fixtures/from/app/root'
    CouchrestRails.views_path     = 'custom/path/to/your/views/from/app/root'
    
Use the rake tasks to create, drop, reset, sync views and load fixtures:

    rake -T | grep couchdb
    
For testing or spec'ing, use these helpers to setup and teardown a test database with fixtures:

    CouchrestRails::Tests.setup
    CouchrestRails::Tests.teardown
    
Views that you want to push up to the CouchDB database/server instance should be in the following format:

    db/couch/views
    |-- <view_name>
        |-- map.js
        `-- reduce.js

## Further development and testing

To run the test suite, you'll need rspec installed with rspec-rails library enabled for the host application. You can run the tests in the following way:

    <rails_root>$ rake spec:plugins
    <plugin_root>$ rake spec
    <plugin_root>$ autospec
    
(The latter requires the ZenTest gem)

## TODO

* Push views with rake tasks
* Shelling out to couchapp to push views seems ... wrong. Do it natively with CouchRest
* A thin CouchDocument class around Couchrest::ExtendedDocument for extending (timestamp hooks, basic views, validation?)
* Documentation
* Restrict model to default attributes and their types?
* Mechanism for better view testing?
* Gemify
* Add more parseable options to couchdb.yml
* Expand beyond a single database per application
* Currently assumes one design document per application--expand

## License

Copyright (c) Henry Poydar, released under the MIT license
