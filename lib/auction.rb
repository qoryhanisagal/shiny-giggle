require 'date'

class Auction
  attr_reader :items

  def initialize
    # Initialize an empty array to store items in the auction
    @items = []
  end

  # Adds an item to the auction
  def add_item(item)
    @items.push(item)
  end

  # Returns an array of item names
  def item_names
    @items.map(&:name)
  end

  # Identifies items with no bids
  # Returns an array of items where the bids hash is empty
  def unpopular_items
    @items.select { |item| item.bids.empty? }
  end

  # Calculates the total potential revenue
  # Adds up the highest bid from each item (or 0 if no bids exist)
  def potential_revenue
    @items.sum { |item| item.current_high_bid.to_i }
  end

  # Compiles a hash of bidder information
  # Keys are attendees, and values are sub-hashes containing:
  # - :budget (remaining budget for the attendee)
  # - :items (items the attendee has bid on)
  def bidder_info
    info = {}
    @items.each do |item|
      item.bids.each do |attendee, _|
        # Initialize the sub-hash for each attendee if it doesn't exist
        info[attendee] ||= { budget: attendee.budget, items: [] }
        # Add the item to the attendee's list of bid items
        info[attendee][:items] << item
      end
    end
    info
  end

  # Returns an array of unique bidder names
  def bidders
    @items.flat_map { |item| item.bids.keys.map(&:name) }.uniq
  end

  # Returns the date the auction was created in "dd/mm/yyyy" format
  def date
    Date.today.strftime("%d/%m/%Y")
  end

  # Closes the auction and sells items to bidders
  # Returns a hash where:
  # - Keys are items
  # - Values are attendees who won the item or "Not Sold" if no one won
  def close_auction
    result = {}
    remaining_bids = []

    # Collect all bids across all items
    @items.each do |item|
      item.bids.each { |attendee, bid| remaining_bids << { attendee: attendee, item: item, bid: bid } }
      result[item] = "Not Sold" # Default to "Not Sold"
    end

    # Sort all bids globally by descending bid amount
    remaining_bids.sort_by! { |bid_hash| -bid_hash[:bid] }

    # Assign items based on affordability and highest bid
    remaining_bids.each do |bid_hash|
      attendee = bid_hash[:attendee]
      item = bid_hash[:item]
      bid = bid_hash[:bid]

      # Check if the item is still available and the attendee can afford it
      if result[item] == "Not Sold" && attendee.budget >= bid
        result[item] = attendee # Assign the item to the attendee
        attendee.budget -= bid # Deduct the bid amount from their budget
      end
    end

    result
  end
end