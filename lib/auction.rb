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

  # Compiles a hash of bidder information(important for Iteration pattern)
  # The hash keys are attendees, and values are sub-hashes with their budget and items they bid on
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
  require 'date'

def date
  Date.today.strftime("%d/%m/%Y")
end

def close_auction
  result = {}

  @items.each do |item|
    bids = item.bids.sort_by { |_attendee, bid| -bid } # Sort bids by descending amount
    result[item] = "Not Sold" # Default to "Not Sold"

    bids.each do |attendee, bid|
      if attendee.budget >= bid
        result[item] = attendee # Assign the item to the highest bidder who can afford it
        attendee.budget -= bid # Deduct the bid amount from the attendee's budget
        break
      end
    end
  end

  result
end
end