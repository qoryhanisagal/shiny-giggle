class Attendee
  attr_reader :name, :budget

  def initialize(details)
    # Initialize attendee with a name and a budget (converted from string to integer)
    @name = details[:name]
    @budget = details[:budget].delete('$').to_i
  end

  # Updates the attendee's budget
  def budget=(new_budget)
    @budget = new_budget
  end
end