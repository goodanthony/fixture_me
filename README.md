# FixtureMe

Generate fixtures and fixture files for testing


If you want to generate fixtures from development database for a Ruby on Rails application here is a helper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fixture_me'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fixture_me

## Usage


```ruby
 rails console
```

Once your are inside Rails console

To generate fixtures for all models.

A new directory called fixtures would be created inside tmp directory (this is to make sure that this fixture generation would not override existing fixtures)


```ruby
 fixme = FixtureMe::AddFixtures.new
 fixme.create_all_fixtures
```

to exclude created_at and updated_at columns

```ruby
 fixme = FixtureMe::AddFixtures.new
 fixme.create_all_fixtures_no_timestamps
```


To generate fixtures one by one

a mymodel.yml file would be generated  inside that file does not exist in the test/fixtures directory

'add_fixture' method would add the new record after the existing fixtures.

```ruby
require "fixture_me"
obj = Mymodel.find(42)
obj.add_fixture
```

To exclude timestamps and ID

```ruby
require "fixture_me"
obj = Mymodel.find(42)
obj.add_fixture_no_id_timestamps
```





On a last note please try to give some tender love to fixtures. There is nothing wrong with them. No doubt Factories are good. But why would you need that when there are fixtures bundled right there with Rails and they work like a charm with Rails.  I'll have a dig at Rspec as well. Why on earth would one use Rspec when there is minitest.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/fixture_me/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
