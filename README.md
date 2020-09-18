# Topolys

Topolys is a Ruby gem based on the rigorous non-manifold topology class hierarchy used in the [Topologic](https://github.com/NonManifoldTopology/Topologic) project. More information about Topologic is available on the [Topologic website](https://topologic.app). This class hierarchy is well suited to the topology of zero thickness space boundaries commonly used in energy modeling as well as other applications.  The Topolys gem is agnostic to specific applications. Current users of Topolys include:

- [Thermal Bridging & Derating (tbd)](https://github.com/rd2/tbd) is a library and OpenStudio Measure for thermally derating outside-facing opaque constructions (walls, roofs and exposed floors), based on major thermal bridges (balconies, corners, fenestration perimeters, and so on).
- [TopolysMeasures](https://github.com/automaticmagic/TopolysMeasures), includes proof of concept OpenStudio Measures with the potential to provide improved surface intersection and matching, checks if spaces are fully enclosed, or other new functionality.

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
