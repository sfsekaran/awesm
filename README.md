# Awesm #

The *awesm* gem is an easy way to access the awe.sm API (http://totally.awe.sm).

We're actively developing this (and it's not yet production ready) but please
feel free to send us a pull request from a topic branch with specs and an
explanation :)

## Usage ##

```ruby
Awesm.subscription_key = 'sub-xxxxxx'
project = Awesm::Project.create(:name => 'Totally Awe.sm!')
project.api_key # => '1234567890abcdefghijklmnopqrstuvwxyz'
```

## Contributing ##

* fork
* clone
* bundle install
* bundle exec rspec spec
* commit code with passing specs
* push to a topic branch
* send us a pull request :)

## Manitainers ##

* *Sathya Sekaran*
* *Michael Durnhofer*
