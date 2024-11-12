class Item 
  attr_reader :name, :bids

  def initialize(name)
    @name = name        # The name of the item being auctioned
    @bids = {}          # A hash to store bids where keys are attendees and values are bid amounts
  end

  # Adds a bid to the item
  def add_bid(attendee, amount)
    @bids[attendee] = amount # Add the attendee as a key and their bid amount as the value to the bids hash
  end
    # Returns the highest bid amount for this item
  def current_high_bid
    @bids.values.max
  end
end
