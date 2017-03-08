require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "implements conjured item updating" do
      items = [Item.new("Conjured Mana Cake", 5, 5)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 3
    end
  end

end
