require 'spec_helper'
require './lib/item'
require './lib/attendee'

RSpec.describe Item do 
  before(:each) do
    # Set up test data before each example
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
  end

  # Check if an Item object is created successfully
  it 'exists' do
    expect(@item1).to be_a(Item)
  end

  # Verify that Item has the correct attributes
  it 'has attributes' do
    expect(@item1.name).to eq("Chalkware Piggy Bank")
    expect(@item2.name).to eq("Bamboo Picture Frame")
  end

  # Confirm that bids can be added to an Item
  it 'can add bids' do
    item = Item.new('Chalkware Piggy Bank') # Create a new item
    attendee = Attendee.new({name: 'Megan', budget: '$50'}) # Create an attendee

    item.add_bid(attendee, 20) # Add a bid to the item

    # Verify the bids hash correctly reflects the added bid
    expect(item.bids).to eq({attendee => 20})
  end

  # Test the close_bidding functionality for an Item
  it 'can close bidding for an item' do
    attendee1 = Attendee.new({name: 'Megan', budget: '$50'})
    attendee2 = Attendee.new({name: 'Bob', budget: '$75'})
    attendee3 = Attendee.new({name: 'Mike', budget: '$100'})

    @item1.add_bid(attendee1, 20)
    @item1.add_bid(attendee2, 25)

    @item1.close_bidding # Close bidding for the item

    # Try to add another bid after bidding is closed
    @item1.add_bid(attendee3, 30)

    # Ensure the bids remain unchanged after closing
    expect(@item1.bids).to eq({attendee1 => 20, attendee2 => 25})
  end
end