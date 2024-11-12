class Item 
  attr_reader :name, :bids

  def initialize(name)
    @name = name        # Initialize the item with its name
    @bids = {}          # Store bids as a hash where keys are attendees and values are bid amounts
    @bidding_closed = false # Track whether bidding is closed
  end

  # Adds a bid to the item, but only if bidding is not closed
  # - attendee: The attendee placing the bid
  # - amount: The amount being bid
  def add_bid(attendee, amount)
    @bids[attendee] = amount unless @bidding_closed
  end

  # Returns the highest bid amount for the item
  def current_high_bid
    @bids.values.max
  end

  # Closes bidding for the item, preventing further bids from being added
  def close_bidding
    @bidding_closed = true
  end
end