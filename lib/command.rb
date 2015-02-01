class Command
  require_relative 'place'
  require_relative 'travel_type'
  require_relative 'error'

  attr_reader :type, :origin, :destination, :convoy, :valid
  CONVOY_MARKER = 'Convoys'

  def initialize(command)
  	parsed = _parse(command)
  	@type = parsed.type
  	@origin = parsed.origin
  	@destination = parsed.destination
  	@convoy = parsed.convoy
  	@valid = _valid?(@type, @origin, @destination)
  end

  def _parse command
  	convoy_marker_index = (command.index(CONVOY_MARKER) || 0) - 1
  	command_without_convoy = command[0..convoy_marker_index]
  	pieces = command_without_convoy.split("-")
  	before_dash = pieces[0].split
  	type = _type(before_dash[0])
  	origin = _place(before_dash[1..-1].join(" ")) # to get multi-word origins
  	convoy = _convoy(command)
  	destination = convoy ? Error::NoDestinationWhenConvoy : _place(pieces[1]) # if it is a convoy, there is no destination
  	OpenStruct.new(
  		type: type, 
  		origin: origin, 
  		destination: destination, 
  		convoy: convoy
  		)
  end

  def _convoy command
  	convoy_pieces = command.split(CONVOY_MARKER)
  	return false unless convoy_pieces.length > 1
  	convoy_marker_index = command.index(CONVOY_MARKER) || -1
  	convoy_command = command[convoy_marker_index..-1].gsub(CONVOY_MARKER, '')
  	Command.new(convoy_command)
  end

  def _valid? type, origin, destination
  	!(origin == destination) && 
  		_type_ok(@type, @origin, @destination)
  end

  def _type_ok type, *places
  	places.map {|p|
  		case type
  		when Type::Army
  			Place::LandAccessible.include? p
  		when Type::Fleet
  			Place::SeaAccessible.include? p
  		else false
  		end
  	}.all?
  end

  def _place place
  	msg = "Unknown place: #{place}"
  	return msg unless place
  	Place::ALL.find {|p| p.downcase == place.strip.downcase	} || msg
  end

  def _type type
  	case type
  	when 'A'
  		Type::Army
  	when 'F'
  		Type::Fleet
  	else "Unknown type: #{type}"
  	end
  end

  def == other
  	# [:type, :origin, :destination, :convoy, :valid].map {|m|
  	# 	other.eval(m) == "@#{m}".to_sym
  	# }.all?
  	other.type == @type &&
  	  other.origin == @origin &&
  	  other.destination == @destination &&
  	  other.convoy == @convoy
  end
end
