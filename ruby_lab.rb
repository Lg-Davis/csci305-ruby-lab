
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Logan Davis
# logand222@gmail.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Logan Davis"
$createTitle = ""
$createCounter = 0


#Step 1
#looking for the third <SEP> three times and then pritning the songTitle after the third <SEP> found
def cleanup_title(songTitle)

#puts songTitle
title = "" 							#setting the varibale title to an empty string
sep_pattern = /<SEP>/ 	#regular expression pattern catching <SEP> in the song lists given

	if songTitle =~ sep_pattern	#checks for the first <SEP>
		title = "#{$'}" #sets title to everything after the first <SEP>
	end

	if title =~ sep_pattern	#checks again for the second <SEP>
		title = "#{$'}" #sets title to everything after the second <SEP>
	end

	if title =~ sep_pattern #checks for the third and final <SEP>
		title = "#{$'}"	#sets title to everything after the third <SEP> which is just the song title
	end


#step2
sf_pattern = /[(\[\{\\\/_\-:"`+=*]|feat./	#pattern to detect superfluous text

	if title =~ sf_pattern #if title contains the superfluous pattern
		title = "#{$`}"	#sets title equal to everything before the superfluous text
	end

#step 3
punc_pattern = /[?¿!¡.;&@%#|]/	#pattern to detect punctuation in the song description

	if title =~ punc_pattern	#checking if the title contains the punctuation pattern
		title.gsub!(punc_pattern, "") #replace punctuation found with empty an empty string in title (deleting punctuation found)
	end

#step 5
title.downcase! #makes all characters in title lowercase

return title
end #end of cleanup_title - method

#Assembling the Bigram - Method
def assemble_bigram(title)
	#using a regualar expression to identify the stop words, and then kill the stop word by saving it into a empty string
	stop_patt = /with\b|to\b|the\b|out\b|or\b|on\b|of\b|in\b|from\b|for\b|by\b|and\b|an\b|a\b/
	title.gsub!(stop_patt,"")
	title_array = title.split
	for i in 0..title_array.length-2
		$bigrams[title_array[i]]
		if $bigrams[title_array[i]] == nil
			$bigrams[title_array[i]] = Hash.new(0)
		end
		$bigrams[title_array[i]][title_array[i+1]] += 1
	end
end


#Most Common Word Method
def mcw(word)
	highest_value = 0
	most_common_key = ""
	$bigrams[word].each do |key, value|
		if value > highest_value
			highest_value = value
			most_common_key = key
		end
	end
	return most_common_key
end


def create_title(starting_word)
	begin
		final_title = starting_word
		length = 0
		previous = starting_word
		fix_array = Array.new

		while length < 19

			current = mcw(previous)

			if(fix_array.include?(current))
				break
			else
				fix_array.push(current)
			end


			if (current != "" && current != nil)
				length += 1
				final_title << " "
				final_title << current
				previous = current
			else
				length = 19
			end
		end
		return final_title
	rescue
		return final_title
	end
end




#function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		if RUBY_PLATFORM.downcase.include? 'mswin'
			file = File.open(file_name)
			unless file.eof?
				file.each_line do |line|
					# do something for each line (if using windows)
				end
			end
			file.close
		else
			IO.foreach(file_name, encoding: "utf-8") do |line|
				# do something for each line (if using macos or linux)
				song = cleanup_title(line) #calls the cleanup_title method with the line from the file given
				assemble_bigram(song)	#calls bigram method with the song variable returned from cleanup_title

			end
			#puts mcw("love")
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
	marker = 0
	while (marker == 0)
		print "Enter a word [Enter 'q-q' to quit]:"
		line = STDIN.gets.chomp
		if line == "q-q"
			marker = 1
		else
			$createTitle = ""
			$createCounter = 0
			puts create_title(line)
		end
	end
end

if __FILE__== $0
	main_loop()
end
