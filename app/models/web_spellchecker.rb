class WebSpellchecker < Spellchecker
  def initialize()
  end
  def known(words)
    res = DictionaryWord.select('word').where(word: words).order('count DESC')
    return res.map{|x| x[:word]}
  end
end
