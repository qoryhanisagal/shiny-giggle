require 'spec_helper'
require './lib/item'
require './lib/auction'
require './lib/attendee'
require 'date'

RSpec.describe Auction do
  before(:each) do
    # Set up test data before each example
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

    @attendee1 = Attendee.new({ name: 'Megan', budget: '$50' })
    @attendee2 = Attendee.new({ name: 'Bob', budget: '$75' })
    @attendee3 = Attendee.new({ name: 'Mike', budget: '$100' })
  end

  it 'exists and has attributes' do
    expect(@auction).to be_a(Auction)
    expect(@auction.items).to eq([@item1, @item2, @item3, @item4, @item5])
  end

  it 'can add items to the auction' do
    expect(@auction.items).to eq([@item1, @item2, @item3, @item4, @item5])
  end

  it 'can identify unpopular items (items with no bids)' do
    @item1.add_bid(@attendee1, 20)
    @item4.add_bid(@attendee3, 50)

    expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])
  end

  it 'updates unpopular items when bids are added' do
    @item1.add_bid(@attendee1, 20)
    @item4.add_bid(@attendee3, 50)

    expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])

    @item3.add_bid(@attendee2, 15)

    expect(@auction.unpopular_items).to eq([@item2, @item5])
  end

  it 'can calculate potential revenue' do
    @item1.add_bid(@attendee1, 20)
    @item1.add_bid(@attendee2, 25)
    @item4.add_bid(@attendee3, 50)
    @item3.add_bid(@attendee2, 15)

    expect(@auction.potential_revenue).to eq(90)
  end

  it 'handles potential revenue with no bids' do
    expect(@auction.potential_revenue).to eq(0)
  end

  it 'handles edge cases for unpopular items' do
    expect(@auction.unpopular_items).to eq([@item1, @item2, @item3, @item4, @item5])

    @item1.add_bid(@attendee1, 20)
    @item2.add_bid(@attendee2, 15)
    @item3.add_bid(@attendee3, 30)
    @item4.add_bid(@attendee1, 40)
    @item5.add_bid(@attendee2, 50)

    expect(@auction.unpopular_items).to eq([])
  end

  it 'can return an array of bidders names' do
    @item1.add_bid(@attendee1, 20)
    @item1.add_bid(@attendee2, 25)
    @item3.add_bid(@attendee3, 15)

    expect(@auction.bidders).to eq(["Megan", "Bob", "Mike"])
  end

  it 'can return bidder info' do
    @item1.add_bid(@attendee1, 20)
    @item1.add_bid(@attendee2, 25)
    @item3.add_bid(@attendee2, 15)
    @item4.add_bid(@attendee3, 50)

    expected = {
      @attendee1 => {
        :budget => 50,
        :items => [@item1]
      },
      @attendee2 => {
        :budget => 75,
        :items => [@item1, @item3]
      },
      @attendee3 => {
        :budget => 100,
        :items => [@item4]
      }
    }

    expect(@auction.bidder_info).to eq(expected)
  end

  it 'returns the date of the auction' do
    allow(Date).to receive(:today).and_return(Date.new(2022, 11, 10)) # Stub today's date
    auction = Auction.new

    expect(auction.date).to eq("10/11/2022")
  end

  it 'can close the auction and sell items to bidders' do
    @item1.add_bid(@attendee1, 50)
    @item1.add_bid(@attendee2, 75) # Bob can't afford this
    @item2.add_bid(@attendee1, 30)
    @item3.add_bid(@attendee2, 20)

    result = @auction.close_auction

    expected = {
      @item1 => @attendee1, # Megan wins because Bob can't afford 75
      @item2 => @attendee1, # Megan wins
      @item3 => @attendee2, # Bob wins
      @item4 => "Not Sold",
      @item5 => "Not Sold"
    }

    expect(result).to eq(expected)
  end
end