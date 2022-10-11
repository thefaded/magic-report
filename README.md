# MagicReport

An easy way to export data to CSV

[![Build Status](https://github.com/thefaded/magic-report/workflows/test/badge.svg?branch=master)](https://github.com/thefaded/magic-report/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "magic-operation"
```

## Getting Started

This gem provides an ActiveRecord-like DSL to create CSV reports. One of the common use cases is when you have nested data.

```ruby
class User < MagicReport::Report
  field :id
  field :is_admin, ->(user) { user.is_admin ? "Yes" : "No" }
end
```

The example above is basic - you have a User model and you want to export the two fields `id` and `is_admin`.
The users of your application may not particularly like the naming `true` or `false` since these are more technical terms, that's why you can pass an additional block to the field.

Also, for each report you must provide locales file:

```yaml
en:
  magic_report:
    headings:
      user:
        id: ID
        is_admin: Admin?
```

CSV will be
| ID | Admin? |
| ---- | -------- |
| 123 | Yes |
| 222 | No |

## Nested

Let's look at a more complex example. Now we have a user model with an address and several cars.

```ruby
class User < MagicReport::Report
  field :id
  field :is_admin, ->(user) { user.is_admin ? "Yes" : "No" }

  has_one :address, class: Address
  has_many :cars, class: Car
end

class Address < MagicReport::Report
  fields :address_line_1, :city
end

class Car < MagicReport::Report
  field :name
end
```

Because we have explicitly said that the user `has_many :cars`, the number of lines in the CSV will be equal to the number of cars.

```yaml
en:
  magic_report:
    headings:
      user:
        id: ID
        is_admin: Admin?
        address: User address
        cars: Car
      car:
        name: Name
      address:
        address_line_1: Line 1
        city: City
```

CSV will be
| ID | Admin? | Address Line 1 | Address City | Car Name |
| ---- | -------- | -------------- | ------------ | -------- |
| 123 | Yes | 5th Ave | NY | Lexus |
| 123 | Yes | 5th Ave | NY | BMW |

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/thefaded/magic-report/issues)
- Fix bugs and [submit pull requests](https://github.com/thefaded/magic-report/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development and testing, check out the [Contributing Guide](CONTRIBUTING.md).
