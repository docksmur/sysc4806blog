require 'set'

class Spellchecker

  
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  #constructor.
  #text_file_name is the path to a local file with text to train the model (find actual words and their #frequency)
  #verbose is a flag to show traces of what's going on (useful for large files)
  def initialize(text_file_name)
    @dictionary = Hash.new(0)
    contents = IO.read(text_file_name)
    wordsInFile = words(contents)
    train!(wordsInFile)
  end

  def dictionary
    return @dictionary
  end
  
  #returns an array of words in the text.
  def words (text)
    return text.downcase.scan(/[a-z]+/) #find all matches of this simple regular expression
  end

  #train model (create dictionary)
  def train!(word_list)
    word_list.each do |s|
      @dictionary[s] += 1
    end
  end

  #lookup frequency of a word, a simple lookup in the @dictionary Hash
  def lookup(word)
    return @dictionary[word]
  end
  
  #generate all correction candidates at an edit distance of 1 from the input word.
  def edits1(word)
    deletes    = []
    letters = word.split("")
    letters.each do |c|
      word2 = word
      deletes.push(word2.delete(c))
    end

    transposes = []
    for i in 0..word.length-1
      letters = word.split("")
      letters2 = letters
      letters2.insert(i+1 , letters2.delete_at(i))
      transposes.push(letters2.join())
    end

    inserts = []
    ALPHABET.split("").each do |c|
        for i in 0..word.length
          letters = word.split("")
          letters2 = letters
          letters2.insert(i,c)
          inserts.push(letters2.join())
        end
    end

    replaces = []
    ALPHABET.split("").each do |c|
	for i in 0..word.length-1
          letters = word.split("")
          letters2 = letters
          letters2.delete_at(i)
          letters2.insert(i,c)
          replaces.push(letters2.join())
        end
    end

    return (deletes + transposes + replaces + inserts).to_set.to_a #eliminate duplicates, then convert back to array
  end
  

  # find known (in dictionary) distance-2 edits of target word.
  def known_edits2 (word)
    dist2 = []
    edits1(word).each do |s|
      dist2 += edits1(s)
    end
    return known(dist2.to_set.to_a)
  end

  #return subset of the input words (argument is an array) that are known by this dictionary
  def known(words)
    temp = words.find_all {|k| @dictionary.key?(k) } 
    res = temp.sort_by do |word|
      @dictionary[word]
    end
    return res.reverse
    #find all words for which condition is true,
                                    #you need to figure out this condition
    
  end


  # if word is known, then
  # returns [word], 
  # else if there are valid distance-1 replacements, 
  # returns distance-1 replacements sorted by descending frequency in the model
  # else if there are valid distance-2 replacements,
  # returns distance-2 replacements sorted by descending frequency in the model
  # else returns nil
  def correct(word)
     if (known([word]).count>0)
       return known([word])
     elsif (known(edits1(word)).count>0)
       return known(edits1(word))
     elsif (known_edits2(word).count>0)
       return known_edits2(word)
     else
       return nil
     end

  end
    
  
end

