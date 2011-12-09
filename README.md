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

    # Notify Awe.sm of a goal conversion
    Awesm::Conversion.convert(
      :key => "5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9",
      :awesm_url => "awe.sm_5WXHo",
      :conversion_type => "goal_1",
      :conversion_value => "1230"
    )

    # Create a sharing link
    Awesm::Url.share(
      :url => 'http://developers.awe.sm/',
      :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :tool => 'mKU7uN',
      :channel => 'twitter',
      :destination => 'http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm',
      :parent => 'awe.sm_s5d99',
      :user_id => '42'
    )
    # => "http://api.awe.sm/url/share?v=3&url=http://developers.awe.sm/&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&tool=mKU7uN&channel=twitter&destination=http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm&parent=awe.sm_s5d99&user_id=42"

## Contributing ##

* fork
* clone
* bundle install
* bundle exec rspec spec
* commit code with passing specs
* push to a topic branch
* send us a pull request :)

## Contributors ##

* *Sathya Sekaran*
* *Michael Durnhofer*
* *Cody Johnston*

## Many Thanks To ##
* our employer, Topspin Media, Inc. (http://topspinmedia.com)
* and the good folks at awe.sm (http://totally.awe.sm)
