# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', -> #when the page has loaded… do all this.
	word = ""
 	# initialize current word to an empty string.
	$("#blogpost_contents").keypress (e) -> #update this line with correct selector and event
		inp = String.fromCharCode(e.which) # get the 1-character string that the user typed
		if (inp.match(/[a-z]/)) #if this was a letter (use .match method and regular expression)
			word = word+inp #add letter to current word
		else
			if (word.length>0) # if the current word is a sequence of letters
				temp = word
				word=""
				$.get 'http://localhost:3000/spellcheck/'+temp, (data) -> #send ajax request with current word.
					$('body').append('<div class= "fix"> did you mean: '+data.suggestions.join(", ")+'?</div>')
