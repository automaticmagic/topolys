# Topolys

Topolys is a Ruby gem based on the rigorous non-manifold topology class hierarchy used in the [Topologic](https://topologic.app/software/) project. This class hierarchy is well suited to the topology of zero thickness space boundaries commonly used in energy modeling as well as other applications.  The Topolys gem is agnostic to specific applications. A separate repository, [TopolysMeasures](https://github.com/automaticmagic/TopolysMeasures), linking Topolys  with OpenStudio has the potential to provide improved surface intersection and matching, checks if spaces are fully enclosed, or other new functionality. 

## Documentation

Topolys is very new and does not yet have formal user documentation.  A set of initial design documents are available at https://github.com/automaticmagic/topolys/tree/master/design

## Installation

(revise) Add this line to your application's Gemfile:

```ruby
gem 'topolys', github: 'automaticmagic/topolys', branch: 'master'
```

And then execute:

    $ bundle update

## Development

To run unit tests:

    bundle exec rake

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/automaticmagic/topolys.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
