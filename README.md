# Awesm #

The *awesm* gem is an easy way to access the awe.sm API (http://totally.awe.sm).

We're actively developing this (and it's not yet production ready) but please
feel free to send us a pull request from a topic branch with specs and an
explanation :)

## Usage ##

In your Gemfile:

    gem 'awesm'

And in your code:

    # Initialize
    Awesm.subscription_key = 'sub-xxxxxx'
    Awesm.application_key = 'app-xxxxxx'

    # Create a project
    project = Awesm::Project.create(:name => 'TotallyAwesm')
    project.api_key # => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9'

    # List projects
    projects = Awesm::Project.list
    projects.first.class # => Awesm::Project

    # Create a sharing link
    # (This is currently very rudimentary--only the options shown will work.)
    Awesm::Url.share(:url => 'http://developers.awe.sm/',
                       :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
                       :tool => 'mKU7uN',
                       :channel => 'twitter',
                       :destination => 'http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm')
    # => "http://api.awe.sm/url/share?v=3&url=http://developers.awe.sm/&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&tool=mKU7uN&channel=twitter&destination=http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm"

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

## Many Thanks To ##
* our employer, Topspin Media, Inc. (http://topspinmedia.com)
* and the good folks at awe.sm (http://totally.awe.sm)
