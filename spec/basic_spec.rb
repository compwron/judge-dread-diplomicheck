require_relative 'spec_helper'
describe Diplomijudge do
  let(:game_state) { {} }
  let(:dj) { Diplomijudge.new(game_state) }

  it '6.A.1 moving to an area that is not a neighbor without using a convoy does not work' do
    command = 'F North Sea - Picardy'
    result = dj.command(Country::England, command)
    expect(result.failed?).to eq true
    expect(result.errors).to include Error::NonNeighborMove
  end

  it '6.A.2 Moving an army to a sea is not possible' do
    command = 'A Liverpool - Irish Sea'
    result = dj.command(Country::England, command)
    expect(result.failed?).to eq true
    expect(result.errors).to include Error::InvalidDestinationType
  end

  it '6.A.3 Moving a fleet to land is not possible' do
    command = 'F Kiel - Munich'
    result = dj.command(Country::Germany, command)
    expect(result.failed?).to eq true
    expect(result.errors).to include Error::InvalidDestinationType
  end

  it '6.A.4 Moving to your own sector is impossible' do
    command = 'F Kiel - Kiel'
    result = dj.command(Country::Germany, command)
    expect(result.failed?).to eq true
    expect(result.errors).to include Error::InvalidDestination
  end

  it '6.A.5 Moving to your own sector with a convoy is impossible' do # this may be a more advanced case
    command1 = 'F North Sea Convoys A Yorkshire - Yorkshire'
    command2 = 'A Yorkshire - Yorkshire' # illegal
    command3 = 'A Liverpool Supports A Yorkshire - Yorkshire' # illegal because move that it is supporting is illegal

    command4 = 'F London - Yorkshire'
    command5 = 'A Wales Supports F London - Yorkshire'

    result1 = dj.command(Country::England, [command1, command2, command3])
    expect(result1.failed?).to eq true
    expect(result1.errors).to include Error::InvalidDestination
    expect(result1.errors).to include Error::SupportsFailedCommand

    result2 = dj.command(Country::Germany, [command4, command5])
    expect(result2.errors).to be_empty
    expect(result2.summary).to eq 'The army in London dislodges the army in Yorkshire.'
  end

  it '6.A.6 Ordering a unit of another country does not work' do
    game_state = { Country::England => { Type::Fleet => [Place::London] } }
    command = 'F London - North Sea'
    result = dj.command(Country::Germany, command)
    expect(result.failed?).to eq true
    expect(result.errors).to include Error::NotControllable
  end
end
