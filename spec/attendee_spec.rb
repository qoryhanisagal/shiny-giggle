require 'spec_helper'

RSpec.describe Attendee do
  before(:each) do
    @attendee = Attendee.new({ name: 'Megan', budget: '$50' })
  end

  it 'exists' do
    expect(@attendee).to be_a(Attendee)
  end

  it 'has attributes' do
    expect(@attendee.name).to eq('Megan')
    expect(@attendee.budget).to eq(50)
  end

  it 'can update budget' do
    @attendee.budget = 30
    expect(@attendee.budget).to eq(30)
  end
end