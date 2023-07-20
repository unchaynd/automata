# Non-deterministic finite-state automaton

class NFA

  def initialize(states:, alphabet:, transitions:, start:, final:)
    # states      => Array of Symbols
    # alphabet    => non-empty Array of Strings, each 1 character long
    # transitions => Hash where all keys are Symbols, and all values are Hashes
    #                where all keys are Strings and all values are non-empty
    #                Arrays of Symbols. Each Symbol must be a member of
    #                'states'. Each String must be either a member of 'alphabet'
    #                or the empty string.
    # start       => Array of Symbols, that is a subset of 'states'. It may only be empty if 'states' is empty.
    # final       => Array of Symbols (subset of 'states')

    # Parameter validation phase

    # 'states' validation
        
    raise TypeError, "`states:' must be of class Array. #{states.class} encountered." \
    unless states.class == Array

    states = states.uniq

    states.each do |s|

      raise TypeError, "`states:' must only contain elements of class Symbol. #{s.class} encountered." \
      unless s.class == Symbol

    end

    # 'alphabet' validation
    
    raise TypeError, "`alphabet:' must be of class Array. #{alphabet.class} encountered." \
    unless alphabet.class == Array

    alphabet = alphabet.uniq

    alphabet.each do |a|

      raise TypeError, "`alphabet:' must contain only elements of class String. #{a.class} encountered." \
      unless a.class == String

      raise ArgumentError, "Strings in `alphabet:' must be exactly 1 character long. #{a.inspect} is #{a.length} characters long." \
      unless a.length == 1

    end

    # 'transitions' validation

    raise TypeError, "`transitions:' must be of class Hash. #{transitions.class} encountered." \
    unless transitions.class == Hash

    transitions.each_pair do |from, transition|

      raise TypeError, "Keys in `transitions:' must be of class Symbol. #{from.class} encountered." \
      unless from.class == Symbol

      raise ArgumentError, "Keys in `transitions:' must be a member of `states:'. #{from.inspect} is invalid." \
      unless states.include? from

      raise TypeError, "Values in `transitions:' must be of class Hash. #{transition.class} encountered." \
      unless transition.class == Hash

      transition.each_pair do |symbol, choices|

        raise TypeError, "Keys in sub-Hashes in `transitions' must be of class String. #{symbol.class} encountered." \
        unless symbol.class == String

        raise ArgumentError, "Keys in sub-Hashes in `transitions:' must be either a member of `alphabet:' or the empty String. #{symbol.inspect} is invalid." \
        unless symbol.empty? or alphabet.include? symbol

        raise TypeError, "Values in sub-Hashes in `transitions:' must be of class Array. #{choices.class} encountered." \
        unless choices.class == Array

        choices.each do |s|
          raise TypeError, "Arrays in sub-Hashes in `transitions:' must contain only elements of class Symbol. #{s.class} encountered." \
          unless s.class == Symbol

          raise ArgumentError, "Arrays in sub-Hashes in `transitions:' must contain only members of `states:'. #{s.inspect} is invalid." \
          unless states.include? s
        end
      end
    end

    # 'start' validation

    raise TypeError, "`start:' must be of class Array. #{start.class} encountered." \
    unless start.class == Array

    raise ArgumentError, "`start:' may not be empty unless `states:' is also empty" \
    if start.empty? and not states.empty?

    start.each do |s|

      raise TypeError, "`start:' must contain only elements of class Symbol. #{s.class} encountered." \
      unless s.class == Symbol
    
      raise ArgumentError, "`start:' must contain only members of `states:'. #{s.inspect} is invalid." \
      unless states.include? s

    end

    # 'final' validation

    raise TypeError, "`final:' must be of class Array. #{final.class} encountered." \
    unless final.class == Array

    final.each do |s|

      raise TypeError, "`final:' must contain only elements of class Symbol. #{s.class} encountered." \
      unless s.class == Symbol
    
      raise ArgumentError, "`final:' must contain only members of `states:'. #{s.inspect} is invalid." \
      unless states.include? s

    end

    # Initialization phase

    @states = states.map { |s| s.dup }
    @alphabet = alphabet.map { |a| a.dup }
    @transitions = {}
    # Potential vulnerability here due to how Strings work as Hash keys in Ruby,
    # but tryng to fix that is outside the scope of this prject
    transitions.each_pair do |from, transition|
      copy = {}
      transition.each_pair do |symbol, options|
        copy[symbol.dup] = options.uniq.map { |o| o.dup }
      end
      @transitions.store from.dup, copy
    end
    @start = start.map { |s| s.dup }
    @final = final.map { |s| s.dup }
    
  end

  def inspect
    "states:\n  #{@states.inspect}\n" \
    "alphabet:\n  #{@alphabet.inspect}\n" \
    "transitions:\n  #{@transitions.inspect}\n" \
    "start:\n  #{@start.inspect}\n" \
    "final:\n  #{@final.inspect}"
  end

  def to_s
    inspect
  end

  def accepts? string
  end
end

nfa = NFA.new(
  states: [:q0],
  alphabet: ['a'],
  transitions: {},
  start: [:q0],
  final: [:q0]
)

puts nfa.inspect