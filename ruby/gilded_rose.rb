class GildedRose

ITEM_STRINGS = {
  brie: 'Aged Brie',
  passes: 'Backstage passes to a TAFKAL80ETC concert',
  sulfuras: 'Sulfuras, Hand of Ragnaros',
  conjured: 'Conjured Mana Cake'
}

  def initialize(items)
    @items = []
    items.each do |item|
      item_type = ITEM_STRINGS.key(item.name)
      item_type ||= :normal
      # puts "item_type #{item_type}"
      def item.update_quality

      end
    end
  end

  def define_update_quality(item, update_proc)
    item.define_singleton_method(:update_quality) do
      update_proc.call
    end
  end

  def update_quality()
    @items.each do |item|
      new_quality = item.quality

      update_proc = Proc.new{ |quality| quality }

      NEW_RULES.each do |rule_proc|
        if rule_proc[:matcher].call(item)
          update_proc = rule_proc[:updater].call(update_proc)
        end
      end

      new_quality = update_proc.call(item.quality)

      # RULES.each do |rule_proc|
      #   if rule_proc[:matcher].call(item)
      #     new_quality = rule_proc[:updater].call(item)
      #   end
      # end

      new_quality = 50 if ITEM_STRINGS[:sulfuras] != item.name && new_quality > 50
      new_quality = [new_quality, 0].max
      item.quality = new_quality

      item.sell_in -= 1 unless ITEM_STRINGS[:sulfuras] == item.name

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

class Brie
