class DFA
	def initialize(states:, alphabet:, transitions:, start:, final:)
		# states	=> Array of Symbol
		# alphabet	=> Array of String, each 1 character long
		# transitions	=> Hash of the form {[qx, a]: qy, ...} where qx and qy are members of "states" and a is a member of "alphabet"
		# start		=> (Symbol) Member of "states"
		# final		=> (Array of Symbol) Subset of "states"

		# Parameter validation phase
		raise TypeError, "`states:' must be of class Array" unless states.class == Array		
		states.each do |s|
			raise TypeError, "`states:' must contain only elements of class Symbol" unless s.class == Symbol
		end		

		raise TypeError, "`alphabet:' must be of class Array" unless alphabet.class == Array
		alphabet.each do |a|
			raise TypeError, "`alphabet:' must contain only elements of class String" unless a.class == String			
			raise ArgumentError, "Strings in `alphabet:' must be exactly one character long" unless a.length == 1
		end

		
		raise TypeError, "`transitions:' must be of class Hash" unless transitions.class == Hash
		transitions.each_pair do |situation, destination|
			raise ArgumentError, "Invalid `transitions:' format. `transitions:' must be of class Hash, with the form `{[qx, a]: qy, ...}' where `qx' and `qy' are members of `states:' and `a' is a member of `alphabet:'" unless
				situation.class == Array and
			   	situation.length == 2 and
			   	states.include?(situation[0]) and
			   	alphabet.include?(situation[1]) and
			   	states.include?(destination)
		end

		# Potential vulnerability here due to not verifying that `start' or members of `final' are of class Symbol
		raise ArgumentError, "`start:' must be a member of `states:'" unless states.include? start

		raise TypeError, "`final:' must be of class Array" unless final.class == Array
		final.each do |s|
			raise ArgumentError, "`final:' must be a subset of `states:'" unless states.include? s
		end		

		# Finally initializing the darn thing
		@states = states
		@alphabet = alphabet
		@transitions = transitions
		@start = start
		@final = final
	end

	def inspect
		# Would be nice to rewrite this at some point so that the output is more visuallyy beautiful
		"states:\n\t#{@states.inspect}\n" \
		"alphabet:\n\t#{@alphabet.inspect}\n" \
		"transitions:\n\t#{@transitions.inspect}\n" \
		"start:\n\t#{@start.inspect}\n" \
		"final:\n\t#{@final.inspect}\n"
	end

	def to_s
		inspect
	end

	def accepts? string
	end

end

dfa = DFA.new(
	states: [:q0],
	alphabet: ['a'],
	transitions: {},
	start: :q0,
	final: [:q0]
)

puts dfa.inspect
