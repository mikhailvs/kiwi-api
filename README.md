# kiwi-api
Ruby bindings for the Kiwi.com API.

## Install
```ruby
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}.git" }

gem 'kiwi-api', gitlab: 'mikhailvs/kiwi-ruby'
````

## Use
```ruby
require 'kiwi/api'

flights = Kiwi::API::Flights.new(
  partner: 'picky',
  currency: 'USD',
  locale: 'en-US'
)

locations = Kiwi::API::Locations.new

dates = Date.parse('1 Jan 2019')..Date.parse('10 Sep 2019')

result = flights.search(
  from: locations.city('washington d.c.').first.code,
  to: locations.country('france').first.code,
  limit: 10,
  depart: dates,
  return: dates,
  nights: 10..15
).data.first

info = {
  to: result.cityTo,
  from: result.cityFrom,
  price: result.price,
  distance: result.distance,
  flight_time: result.fly_duration,
  leave: Time.at(result.dTime)
}

puts info.inspect

```