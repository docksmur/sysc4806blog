class DictionaryWordsController < ApplicationController
  def spellcheck
    input_word = params[:term]
    @spellcheck = "we want to check the word #{input_word}"
  end
end
