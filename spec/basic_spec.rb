require_relative 'spec_helper'
describe Diplomijudge do
	let(:game_state) {{}}
	let(:dj) {Diplomijudge.new(game_state)}
	it "6.A.1 moving to an area that is not a neighbor without using a convoy does not work" do
		command = F North Sea - Picardy
		result = dj.command(Country::England, command)
		expect(result.failed?).to eq true
		expect(result.errors).to include Error::NonNeighborMove
	end
end