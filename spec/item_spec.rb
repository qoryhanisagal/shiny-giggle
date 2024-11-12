require 'spec_helper'
require './lib/item'
require './lib/attendee'

RSpec.describe Item do 
  before(:each) do
    # Set up test data before each example
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
  end

  # Test to check if an Item object is created successfully
  it 'exists' do
    expect(@item1).to be_a(Item)
  end

  # Test to verify that Item has the correct attributes
  it 'has attributes' do
    expect(@item1.name).to eq("Chalkware Piggy Bank")
    expect(@item2.name).to eq("Bamboo Picture Frame")
  end

  # Test to verify that bids can be added to an Item
  it 'can add bids' do
    item = Item.new('Chalkware Piggy Bank') # Create a new item
    attendee = Attendee.new({name: 'Megan', budget: '$50'}) # Create an attendee

    item.add_bid(attendee, 20) # Add a bid to the item

    # Expect the bids hash to correctly reflect the added bid
    expect(item.bids).to eq({attendee => 20})
  end
end