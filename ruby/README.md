# Ruby refactoring of the Gilded Rose Kata

## Testing notes

There are two sets of tests: standard unit tests, and legacy conformance.

To run unit tests, use `rspec gilded_rose_spec.rb`

To test the code against saved historical outputs, use `rspec gilded_rose_conformance_spec.rb`

To generate historical data for future testing, use `ruby generate_data.rb [name of the item] [sell_in value] [quality value] [number of days to generate test results for]`. Unless the default location is changed in the code, test cases are saved in the `./test_data` directory.

## Development notes

The guiding assumptions are:

* There can be multiple active rules affecting quality, e.g. an item can be both conjured and past its sell by date, and thus degrade 4x more quickly.
* Rules that affect quality can be represented by a hierarchy, such that an active rule will override any conflicting rules with lower importance.
* The 'types of rule' currently required include `-1 each day`, `degrade twice as fast`, `+1 each day`, `do not change`, `cannot be less than zero`, `cannot be more than 50`
* Things that affect whether a rule is active include `type of product`, `sell_in`. A single item can have multiple rules, depending on both type of product and sell_in. E.g. a backstage pass that also has 0 < sell_in <= 5 days left increases by 3 each day

So, a way of representing these rules in hierarchical form is as an array, with the `type of product` (including `all`), the `sell_in` range that it applies to, and the `effect` on quality. How to manage the hierarchy and effect conflicts requires more thought.

## Tasks

- [x] Add legacy test framework
- [x] Generate legacy test cases for future comparison
- [ ] Refactor the legacy test code to use CSV::Table for clearer code
- [ ] Create tests for the new 'conjured' status
- [ ] Pass the new 'conjured' status
