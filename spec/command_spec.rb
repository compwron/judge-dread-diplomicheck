require_relative 'spec_helper'
describe Command do

  it 'fleet from location to destination (valid)' do
    c = Command.new('F North Sea - Picardy')
    expect(c.type).to eq Type::Fleet
    expect(c.origin).to eq Place::NorthSea
    expect(c.destination).to eq Place::Picardy
    expect(c.convoy).to be false
    expect(c.valid).to be true
  end

   it 'army from sea location to destination' do
    c = Command.new('A North Sea - Picardy')
    expect(c.type).to eq Type::Army
    expect(c.origin).to eq Place::NorthSea
    expect(c.destination).to eq Place::Picardy
    expect(c.convoy).to be false
    expect(c.valid).to be false
  end

  it 'fleet convoy' do
    c = Command.new('F North Sea Convoys A Yorkshire - Yorkshire')
    expect(c.type).to eq Type::Fleet
    expect(c.origin).to eq Place::NorthSea
    expect(c.destination).to be Error::NoDestinationWhenConvoy
    expect(c.convoy).to eq Command.new('A Yorkshire - Yorkshire')
    expect(c.valid).to be false # not invalid by itself; only in context
  end

  it 'invalid order for moving to same place' do
    c = Command.new('A Yorkshire - Yorkshire')
    expect(c.type).to eq Type::Army
    expect(c.origin).to eq Place::Yorkshire
    expect(c.destination).to eq Place::Yorkshire
    expect(c.convoy).to be false
    expect(c.valid).to be false
  end

  xit 'army from location to destination (valid)'
  xit 'multiword destatination place'
end
