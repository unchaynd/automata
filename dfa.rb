class DFA
  def initialize(states:, alphabet:, transitions:, start:, final:)
    # states		=> Array of Symbols, without duplicates
    # alphabet		=> Array of Strings, each 1 character long, without duplicates
    # transitions	=> Hash where all keys are Symbols, and all values are Hashes
    # 			   where all keys are Strings and all values are Symbols.
    #			   Each Symbol must be a member of `states'. This Hash must
    #			   have an entry for each member of `states'. Each String
    #			   must be a member of `alphabet', and each sub-Hash must
    #			   have an entry for each member of `alphabet'. 
    # start		=> Member of `states'
    # final		=> Subset of `states', without duplicates

    # Parameter validation phase

    raise TypeError, "`states:' must be of class Array" \
    unless states.class == Array

    states = states.uniq

    raise TypeError, "`states:' must contain only elements of class Symbol" \
    unless states.all? { |s| s.class == Symbol }

    raise TypeError, "`alphabet:' must be of class Array" \
    unless alphabet.class == Array

    alphabet = alphabet.uniq

    alphabet.each do |a|
    
      raise TypeError, "`alphabet:' must contain only elements of class String" \
      unless a.class == String
    
      raise ArgumentError, "Strings in `alphabet:' must be exactly one character long" \
      unless a.length == 1

    end

    raise ArgumentError, "`start:' must be a member of `states:'" \
    unless states.include? start

    raise TypeError, "`final:' must be of class Array" \
    unless final.class == Array

    final = final.uniq

    raise ArgumentError, "`final:' must be a subset of `states:'" \
    unless final.all? { |s| states.include? s }
		
    raise TypeError, "`transitions:' must be of class Hash" \
    unless transitions.class == Hash

    transitions.each_pair do |from, transition|

      raise TypeError, "Invalid type in `transitions:'" \
      unless from.class == Symbol and
      transition.class == Hash and
      transition.keys.all? { |symbol| symbol.class == String } and
      transition.values.all? { |to| to.class == Symbol }

    end

    raise ArgumentError, "`transitions:' must have an entry for each member of `states:'" \
    unless states.all? { |s| transitions.has_key? s }

    raise ArgumentError, "Extraneous entry found in `transitions:'" \
    unless transitions.keys.all? { |from| states.include? from }

    raise ArgumentError, "Each Hash in `transitions:' must have an entry for each member of `alphabet:'" \
    unless transitions.values.all? do |transition|
      alphabet.all? { |symbol| transition.has_key? symbol }
    end

    transitions.values.all? do |transition|

      raise ArgumentError, "Each Hash in `transitions:' must have an entry for each member of `alphabet:'" \
      unless alphabet.all? { |symbol| transition.has_key? symbol }

      raise ArgumentError, "Extraneous entry found in Hash in `transitions:'" \
      unless transition.keys.all? { |symbol| alphabet.include? symbol }

      raise ArgumentError, "Nonexistent destination state found in `transitions:'" \
      unless transition.values.all? { |to| states.include? to }

    end

    # Finally initializing the darn thing

    @states = states.map { |s| s.dup }
    @alphabet = alphabet.map { |a| a.dup }
    @transitions = {}
    transitions.each_pair do |from, transition|
      copy = {}
      transition.each_pair do |symbol, to|
        copy.store symbol.dup, to.dup
      end
      @transitions.store from.dup, copy
    end
    @start = start.dup
    @final = final.map { |f| f.dup }
  end

  def inspect
    # Would be nice to rewrite this at some point so that the output is more visually beautiful
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
    string.each_char do |c|
      raise ArgumentError, 'invalid character in string' \
      unless @alphabet.include? c
    end

    state = @start
    string.each_char do |symbol|
      state = @transitions[state][symbol]
      return false if state.nil?
    end
    return @final.include? state
  end

end

dfa = DFA.new(
  states: [:q0],
  alphabet: ['a'],
  transitions: {
    q0: {
      'a' => :q0
    }
  },
  start: :q0,
  final: [:q0]
)

puts dfa.inspect

puts "\nEnter a string to test:"
string = gets.chomp("\n")

begin
  puts "The DFA #{dfa.accepts?(string) ? 'accepts' : 'doesn\'t accept'} the string #{string.inspect}."
rescue ArgumentError
  puts "The string #{string.inspect} contains a symbol that is not part of the DFA's alphabet."
end