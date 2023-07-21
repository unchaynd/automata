# Non-deterministic finite-state automaton

class NFA

  def initialize(states:, alphabet:, delta:, start:, final:)
    # states   => Array of Symbols
    # alphabet => non-empty Array of Strings, each 1 character long
    # delta    => Hash where all keys are Symbols, and all values are Hashes
    #             where all keys are Strings and all values are non-empty
    #             Arrays of Symbols. Each Symbol must be a member of
    #             'states'. Each String must be either a member of 'alphabet'
    #             or the empty string.
    # start    => Array of Symbols, that is a subset of 'states'. It may only be empty if 'states' is empty.
    # final    => Array of Symbols (subset of 'states')

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

    # 'delta' validation

    raise TypeError, "`delta:' must be of class Hash. #{delta.class} encountered." \
    unless delta.class == Hash

    delta.each_pair do |from, transition|

      raise TypeError, "Keys in `delta:' must be of class Symbol. #{from.class} encountered." \
      unless from.class == Symbol

      raise ArgumentError, "Keys in `delta:' must be a member of `states:'. #{from.inspect} is invalid." \
      unless states.include? from

      raise TypeError, "Values in `delta:' must be of class Hash. #{transition.class} encountered." \
      unless transition.class == Hash

      transition.each_pair do |symbol, choices|

        raise TypeError, "Keys in sub-Hashes in `delta:' must be of class String. #{symbol.class} encountered." \
        unless symbol.class == String

        raise ArgumentError, "Keys in sub-Hashes in `delta:' must be either a member of `alphabet:' or the empty String. #{symbol.inspect} is invalid." \
        unless symbol.empty? or alphabet.include? symbol

        raise TypeError, "Values in sub-Hashes in `delta:' must be of class Array. #{choices.class} encountered." \
        unless choices.class == Array

        choices.each do |s|
          raise TypeError, "Arrays in sub-Hashes in `delta:' must contain only elements of class Symbol. #{s.class} encountered." \
          unless s.class == Symbol

          raise ArgumentError, "Arrays in sub-Hashes in `delta:' must contain only members of `states:'. #{s.inspect} is invalid." \
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
    @delta = {}
    # Potential vulnerability here due to how Strings work as Hash keys in Ruby,
    # but tryng to fix that is outside the scope of this prject
    delta.each_pair do |from, transition|
      copy = {}
      transition.each_pair do |symbol, options|
        copy[symbol.dup] = options.uniq.map { |o| o.dup }
      end
      @delta.store from.dup, copy
    end
    @start = start.map { |s| s.dup }
    @final = final.map { |s| s.dup }
    
  end

  def inspect
    "states:\n  #{@states.inspect}\n" \
    "alphabet:\n  #{@alphabet.inspect}\n" \
    "delta:\n  #{@delta.inspect}\n" \
    "start:\n  #{@start.inspect}\n" \
    "final:\n  #{@final.inspect}"
  end

  def to_s
    inspect
  end

  def accepts? string

    # check that the input string is valid
    string.each_char do |c|
      raise ArgumentError, 'invalid character in string' \
      unless @alphabet.include? c
    end

    # this variable is used to hold the set of possible states that the NFA could be in at each step
    p = @start.dup

    string.each_char do |symbol|

      # calculate the epsilon closure
      stack = p.dup
      until stack.empty?
        state = stack.pop
        if @delta[state].has_key? ''
          @delta[state][''].each do |to|
            if p.include? to
              next
            else
              p << to
              stack.push to
            end
          end
        end
      end

      # construct a new set of possible states based on the current symbol
      new_p = []
      p.each do |state|
        if @delta[state].has_key? symbol
          new_p = new_p.union @delta[state][symbol]
        end
      end

      # if the new set is empty, a dead end has been reached
      return false if new_p.empty?

      # otherwise, continue on
      p = new_p

    end

    # if any of the possible end states are in the 'final' set, then the string is accepted
    if p.intersection(@final).empty?
      return false
    else
      return true
    end

  end

end

nfa = NFA.new(
  states: [:q0],
  alphabet: ['a'],
  delta: {},
  start: [:q0],
  final: [:q0]
)

puts nfa.inspect