class Diplomijudge
  require_relative 'command'
  require_relative 'game_state'
  require_relative 'country'
  require 'ostruct'
  def initialize(game_state)
    @game_state = GameState.new(game_state)
  end

  def command(_country, command)
    command = Command.new(command)
    result = OpenStruct.new(failed?: true, errors: [Error::NonNeighborMove])
  end
end
