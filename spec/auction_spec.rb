require 'spec_helper'
require './lib/item'
require './lib/auction'
require './lib/attendee'

RSpec.describe Auction do
  before(:each) do
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
    @item3 = Item.new('Homemade Chocolate Chip Cookies')
    @item4 = Item.new('2 Days Dogsitting')
    @item5 = Item.new('Forever Stamps')
    @auction = Auction.new

    @auction.add_item(@item1)
    @auction.add_item(@item2)
    @auction.add_item(@item3)
    @auction.add_item(@item4)
    @auction.add_item(@item5)

    @attendee1 = Attendee.new({name: 'Megan', budget: '$50'})
    @attendee2 = Attendee.new({name: 'Bob', budget: '$75'})
    @attendee3 = Attendee.new({name: 'Mike', budget: '$100'})
  end

  it 'exists and has attributes' do
    expect(@auction).to be_a(Auction)
    expect(@auction.items).to eq([@item1, @item2, @item3, @item4, @item5])
  end

  it 'can add items to the auction' do
    expect(@auction.items).to eq([@item1, @item2, @item3, @item4, @item5])
  end

  it 'can identify unpopular items (items with no bids)' do
    # Add bids to items
    @item1.add_bid(@attendee1, 20)
    @item4.add_bid(@attendee3, 50)

    # Items with no bids are identified as unpopular
    expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])
  end

  it 'updates unpopular items when bids are added' do
    # Add bids to items
    @item1.add_bid(@attendee1, 20)
    @item4.add_bid(@attendee3, 50)

    expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])

    # Add a bid to item 3
    @item3.add_bid(@attendee2, 15)

    # Unpopular items excludes the item that received a bid
    expect(@auction.unpopular_items).to eq([@item2, @item5])
  end

  it 'can calculate potential revenue' do
    # Add multiple bids to items
    @item1.add_bid(@attendee1, 20)
    @item1.add_bid(@attendee2, 25)
    @item4.add_bid(@attendee3, 50)
    @item3.add_bid(@attendee2, 15)

    # Potential revenue is the sum of the highest bids
    expect(@auction.potential_revenue).to eq(90)
  end

  it 'handles potential revenue with no bids' do
    # No bids added to any items
    expect(@auction.potential_revenue).to eq(0)
  end

  it 'handles edge cases for unpopular items' do
    # No bids added initially
    expect(@auction.unpopular_items).to eq([@item1, @item2, @item3, @item4, @item5])

    # Add bids to all items
    @item1.add_bid(@attendee1, 20)
    @item2.add_bid(@attendee2, 15)
    @item3.add_bid(@attendee3, 30)
    @item4.add_bid(@attendee1, 40)
    @item5.add_bid(@attendee2, 50)

    # All items have bids; there should be no unpopular items
    expect(@auction.unpopular_items).to eq([])
  end
end