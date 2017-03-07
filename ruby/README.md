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

So, a way of representing these rules in hierarchical form is as an array, with the `type of product` (including `all`), the `sell_in` range that it applies to, and the `effect` on quality. In terms of code structure, an array of update rules operating on the item, each consisting of a matcher proc that checks if the rule applies to the item, and an update proc that outputs the new item state.

## Tasks

- [x] Add legacy test framework
- [x] Generate legacy test cases for future comparison
- [ ] Refactor the update_quality method for easier maintenance and updating
- [ ] Refactor the legacy test code to use CSV::Table for clearer code
- [ ] Create tests for the new 'conjured' status
- [ ] Pass the new 'conjured' status

## Rules hierarchy

In each of the following lists, further down items take precedence over preceding ones. Except for the `Conjured Mana Cake`, the behaviours are taken from the existing code base rather than the stated rules.

For quality:

* -1 each day for all
* +1 each day for `Aged Brie`, `Backstage passes to a TAFKAL80ETC concert`
* +2 each day for `Backstage passes to a TAFKAL80ETC concert` when sell_in < 11
* +3 each day for `Backstage passes to a TAFKAL80ETC concert` when sell_in < 6
* -2 each day for all when sell_in < 0
* =0 for `Backstage passes to a TAFKAL80ETC concert` when sell_in < 0
* +2 each day for `Aged Brie` when sell_in < 0
* (previous_value*2 each day for `Conjured Mana Cake`)
* +0 each day for `Sulfuras, Hand of Ragnaros`

Then the boundaries:

* min(item_quality, 50) for all except `Sulfuras, Hand of Ragnaros`
* max(item.quality, 0)

For sell_in:

* -1 each day for all
* +0 each day for `Sulfuras, Hand of Ragnaros`
