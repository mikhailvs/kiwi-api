# kiwi-api
Ruby bindings for the Kiwi.com API.

## Install
```ruby
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }

gem 'kiwi-api', gitlab: 'mikhailvs/kiwi-api'
````

## Use
```ruby
require 'kiwi/api'

flights = Kiwi::API::Flights.new(
  partner: 'picky',
  currency: 'USD',
  locale: 'en-US'
)

results = flights.search(
  from: 'SEA',
  to: 'RU',
  limit: 10,
  depart: Date.parse('1 Nov 2018')..Date.parse('1 Feb 2019'),
  return: Date.parse('1 Nov 2018')..Date.parse('1 Feb 2019'),
  nights: 20
)

puts results.inspect

locations = Kiwi::API::Locations.new

puts locations.country('ireland').inspect

```