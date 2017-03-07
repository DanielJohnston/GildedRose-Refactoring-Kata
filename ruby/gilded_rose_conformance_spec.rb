# This repeats a large number of saved test cases to check resuls don't change
require File.join(File.dirname(__FILE__), 'gilded_rose')

require 'csv'
# The pattern to look for saved test case files
SAVED_TESTS_MATCHER = "./test_data/*.csv"

# Some concern that this isn't a *unit* test since it uses the Item class
describe GildedRose do
  describe "#update_quality" do
    context "produces predictable results" do
      test_files = Dir[SAVED_TESTS_MATCHER]
      test_files.each do |test_file|
        it "for #{test_file}" do
        # Get the initial item information
        test_table = CSV.read(test_file)
        name = test_table[0][1].to_s
        sell_in = test_table[0][2].to_i
        quality = test_table[0][3].to_i

        # Create the tavern with the initial item state
        item = Item.new(name=name, sell_in=sell_in, quality=quality)
        gilded_rose = GildedRose.new [item]
        day = 0

        # iterate through the CSV, checking similarity after each day
        test_table.each do |test_row|
          expect([day.to_s, item.name.to_s, item.sell_in.to_s, item.quality.to_s]).to eq test_row
          gilded_rose.update_quality
          day += 1
        end
      end
      end
    end
  end
end
