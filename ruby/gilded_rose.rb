class GildedRose

CHANGE_QUALITY = -1
CHANGE_SELL_IN = -1

UPDATE_RULES = [
  # All items default change
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    true },
    updater: Proc.new{ |item, change_quality, change_sell_in|
    item.sell_in <= 0 ? [-2, -1] : [-1, -1] }},
  # Aged Brie
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    item.name == 'Aged Brie' },
    updater: Proc.new{ |item, change_quality, change_sell_in|
    [item.sell_in <= 0 ? 2 : 1, change_sell_in] }},
  # Backstage passes
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    item.name == 'Backstage passes to a TAFKAL80ETC concert' },
    updater: Proc.new{ |item, change_quality, change_sell_in|
    change_quality = 1
    change_quality = 2 if item.sell_in < 11
    change_quality = 3 if item.sell_in < 6
    change_quality = -item.quality if item.sell_in <=0
    [change_quality, change_sell_in] }},
  # Conjured Mana Cake
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    item.name == 'Conjured Mana Cake' },
    updater: Proc.new{ |item, change_quality, change_sell_in|
    change_quality *= 2 if change_quality < 0
    [change_quality, change_sell_in] }},
  # Item quality > 50
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    item.quality + change_quality > 50 },
    updater: Proc.new{ |item, change_quality, change_sell_in|
    [50 - item.quality, change_sell_in] }},
  # Item quality < 0
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    item.quality + change_quality < 0 },
    updater: Proc.new{ |item, change_quality, change_sell_in|
    [0 - item.quality, change_sell_in] }},
  # Sulfuras
  { matcher: Proc.new{ |item, change_quality, change_sell_in|
    item.name == 'Sulfuras, Hand of Ragnaros' },
    updater: Proc.new{ |item, change_quality, change_sell_in|
      [0, 0] }}
]

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      # Initialise default quality reduction and sell_in reduction
      change_quality = CHANGE_QUALITY
      change_sell_in = CHANGE_SELL_IN

      # Iterate through the rules in order, updating changes to quality and sell_in
      UPDATE_RULES.each do |update_rule|
        if update_rule[:matcher].call(item, change_quality, change_sell_in)
          change_quality, change_sell_in = update_rule[:updater].call(item, change_quality, change_sell_in)
        end
      end

      # Apply changes to quality and sell_in
      item.quality += change_quality
      item.sell_in += change_sell_in
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
