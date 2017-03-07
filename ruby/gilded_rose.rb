class GildedRose

ITEM_STRINGS = {
  brie: 'Aged Brie',
  passes: 'Backstage passes to a TAFKAL80ETC concert',
  sulfuras: 'Sulfuras, Hand of Ragnaros'
}

NEW_RULES = [
  { matcher: Proc.new{ true },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality - 1 }}
  },
  { matcher: Proc.new{ |item| ITEM_STRINGS.values_at(:brie, :passes).include? item.name },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality + 1 }}
  },
  { matcher: Proc.new{ |item| ITEM_STRINGS[:passes] == item.name && item.sell_in < 11 },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality + 2 }}
  },
  { matcher: Proc.new{ |item| ITEM_STRINGS[:passes] == item.name && item.sell_in < 6 },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality + 3 }}
  },
  { matcher: Proc.new{ |item| item.sell_in <= 0 },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality - 2 }}
  },
  { matcher: Proc.new{ |item| item.sell_in <= 0 && ITEM_STRINGS[:passes] == item.name },
  updater: Proc.new{ |updater| Proc.new{ |quality| 0 }}
  },
  { matcher: Proc.new{ |item| item.sell_in <= 0 && ITEM_STRINGS[:brie] == item.name },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality + 2 }}
  },
  # { matcher: Proc.new{ true },
  #   updater: Proc.new{ |updater| [updater.call, 0].max }
  # },

  { matcher: Proc.new{ |item| ITEM_STRINGS[:sulfuras] == item.name },
  updater: Proc.new{ |updater| Proc.new{ |quality| quality + 0 }}
  }
]

RULES = [
  { matcher: Proc.new{ |item| true },
  updater: Proc.new{ |item| item.quality - 1 }},
  { matcher: Proc.new{ |item| ITEM_STRINGS.values_at(:brie, :passes).include? item.name },
  updater: Proc.new{ |item| item.quality + 1 }},
  { matcher: Proc.new{ |item| ITEM_STRINGS[:passes] == item.name && item.sell_in < 11 },
  updater: Proc.new{ |item| item.quality + 2 }},
  { matcher: Proc.new{ |item| ITEM_STRINGS[:passes] == item.name && item.sell_in < 6 },
  updater: Proc.new{ |item| item.quality + 3 }},
  { matcher: Proc.new{ |item| item.sell_in <= 0 },
  updater: Proc.new{ |item| item.quality - 2 }},
  { matcher: Proc.new{ |item| item.sell_in <= 0 && ITEM_STRINGS[:passes] == item.name },
  updater: Proc.new{ |item| 0 }},
  { matcher: Proc.new{ |item| item.sell_in <= 0 && ITEM_STRINGS[:brie] == item.name },
  updater: Proc.new{ |item| item.quality + 2 }},
  { matcher: Proc.new{ |item| ITEM_STRINGS[:sulfuras] == item.name },
  updater: Proc.new{ |item| item.quality + 0 }}
]
# ,
# { matcher: Proc.new{ |item| item.quality > 50 && ITEM_STRINGS[:sulfuras] != item.name },
# updater: Proc.new{ |item| item.quality = 50 }},
#
# { matcher: Proc.new{ |item| item.quality < 0 },
# updater: Proc.new{ |item| item.quality = 0 }},
# { matcher: Proc.new{ |item| ITEM_STRINGS[:sulfuras] != item.name },
# updater: Proc.new{ |item| item.sell_in = 50 }},

  def initialize(items)
    @items = items
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
