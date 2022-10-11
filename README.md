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

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/thefaded/magic-report/issues)
- Fix bugs and [submit pull requests](https://github.com/thefaded/magic-report/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development and testing, check out the [Contributing Guide](CONTRIBUTING.md).
