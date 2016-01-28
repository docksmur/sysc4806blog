class DictionaryWordsController < ApplicationController
  require "#{Rails.root}/app/models/web_spellchecker.rb"
  def spellcheck
    wsc = WebSpellchecker. new
    input = params[:term]
    good_word = wsc.known([input]).count>0
    hash = {"term"=>input, "known" => good_word}
    if !good_word
      hash["suggestions"] = wsc.correct(input)
    end
    render json: hash
  end
end
