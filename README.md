# Awesm #

The *awesm* gem is an easy way to access the awe.sm API (http://developers.awe.sm).

You can find the YARD documentation for the latest release here: http://rdoc.info/github/sfsekaran/awesm/frames

We're actively developing this, so please
feel free to send us pull requests for changes
from a topic branch with specs,
documentation, and an explanation :)

[![Build Status](https://travis-ci.org/sfsekaran/awesm.png)](https://travis-ci.org/sfsekaran/awesm)

## Usage ##

In your Gemfile:

    gem 'awesm'

And in your code:

    # Initialize
    Awesm.subscription_key = 'sub-xxxxxx'
    Awesm.application_key = 'app-xxxxxx'

    # Create a project
    project = Awesm::Project.create({
      :name => "myNewProject",
      :domains => [
        "examp.le",
        "demo.examp.le"
      ],
      :default_domain => "examp.le",
      :admins => [
        "jeremiah"
      ],
      :sharers => [
        "paul@example.com"
      ],
      :viewers => [
        "9x69x9x0-42x1-420x-9876-123139064x99"
      ],
      :conversions => {
        :enabled => true,
        :domains => [
          "example.com",
          "www.example.com",
          "example.net"
        ],
        :goal_1_label => "Liked our Facebook Page",
        :goal_2_label => "Downloaded Photo of the Day",
        :goal_3_label => "Purchase"
      }
    })
    project.api_key # => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9'
    # or
    project = Awesm::Project.new(:name => 'TotallyAwesm')
    project.save # => true
    project.api_key # => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045e9'

    # List projects
    projects = Awesm::Project.list
    projects.first.class # => Awesm::Project

    # Delete a project
    project.destroy # => true

    # Notify Awe.sm of a goal conversion
    Awesm::Conversion.convert(
      :key => "f2d8aeb112f1e0bedd7c05653e3265d2622635a3180f336f73b172267f7fe6ee",
      :awesm_url => "awe.sm_5WXHo",
      :conversion_type => "goal_1",
      :conversion_value => 1230
    )
    # => #<Awesm::Conversion account_conversionid=nil account_id="12" account_userid=nil awesm_url="awe.sm_5WXHo" clicker_id=nil converted_at=1323475432 href=nil id="bfdaddec-2298-43fb-9da0-f12d81febbf6" ip_address=nil language=nil redirection_id="94585739" referrer=nil session_id=nil type="goal_1" user_agent=nil value=1230>

    # List projects
    projects = Awesm::Project.list
    projects.first.class # => Awesm::Project

    # Create an awesm url
    url = Awesm::Url.create(
      :channel => 'twitter',
      :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :tool => 'mKU7uN',
      :url => 'http://developers.awe.sm/'
    )
    url.awesm_url # => "http://demo.awe.sm/ELZ"

    # Create a static url
    url = Awesm::Url.static(
      :url => 'http://developers.awe.sm/',
      :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :tool => 'mKU7uN'
    )
    url.awesm_url # => "http://demo.awe.sm/ELZ"

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

    # Create a static link
    url = Awesm::Url.static(
      :format => 'json',
      :url => 'http://developers.awe.sm/',
      :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :tool => 'mKU7uN'
    )
    url.awesm_url # => "http://demo.awe.sm/ELZ"

	# Use 'update' to set / change properties for a recently created Url
	url = Awesm::Url.update( url.awesm_id,
	  :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :tool => 'mKU7uN', 
      :tag => 'foobar'
    )
    url.tag # => 'foobar'


    # Retrieve stats in return for your hard work!
    stats = Awesm::Stats.range(
      :key        => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :start_date => '2011-09-01',
      :end_date   => '2011-10-01'
    )
    stats.totals.clicks # => 1024

	# Similar to 'range', but gets all-time totals for links created during the given time span
    stats = Awesm::Stats.totals(
      :key        => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :start_date => '2011-09-01',
      :end_date   => '2011-10-01'
    )
    stats.totals.clicks # => 4096

    url_stats = Awesm::Stats.url(
      :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
      :awesm_id => 'demo.awe.sm_K7e'
    )
    url_stats.clicks # => 256

## Maintainers ##

* *Sathya Sekaran*
* *Michael Durnhofer*

## Contributing ##

* fork
* clone
* bundle install
* bundle exec rspec spec
* commit code with passing specs and documentation
* push to a topic branch
* send us a pull request :)

## Contributors ##

http://github.com/sfsekaran/awesm/graphs/contributors

## Many Thanks To ##

* Our former employer, Topspin Media, Inc. (http://topspinmedia.com)
* The good folks at Awe.sm! (http://totally.awe.sm)

## Disclaimer ##

This gem is in no way maintained by the company Awe.sm, and is third party software written and collaborated on by the development community at large.

## The MIT License (MIT) ##

Copyright (c) 2013 Sathya Sekaran, Michael Durnhofer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

