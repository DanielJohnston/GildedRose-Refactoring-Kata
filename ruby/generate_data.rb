require File.join(File.dirname(__FILE__), 'gilded_rose')

require 'csv'

OUTPUT_FOLDER = "./test_data/"

name = ARGV[0].to_s
sell_in = ARGV[1].to_i
quality = ARGV[2].to_i
days = ARGV[3].to_i

# Create the tavern with the initial item state
item = Item.new(name=name, sell_in=sell_in, quality=quality)
gilded_rose = GildedRose.new [item]

# The filename where the data gets saved
filename = OUTPUT_FOLDER + name + " - " + sell_in.to_s + " - " + quality.to_s + " - " + days.to_s + ".csv"

# Output a file with headers and one row for each day's item states
CSV.open(filename, "wb") do |csv|
    # csv << ["day","name","sell_in","quality"]
    (0..days).each do |day|
      csv << [day, item.name, item.sell_in, item.quality]
      gilded_rose.update_quality
    end
end
