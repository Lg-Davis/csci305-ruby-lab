
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
$name = "Logan Davis" #name
$GLtitle = "" #global - empty title variable
$GLcounter = 0 #global - counter varibale initialzied to 0


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
	#using a regualar expression to identify the stop words
	stop_patt = /with\b|to\b|the\b|out\b|or\b|on\b|of\b|in\b|from\b|for\b|by\b|and\b|an\b|a\b/
	title.gsub!(stop_patt,"")  #kill the stop word by saving it into a empty string

	title_array = title.split
	for i in 0..title_array.length-2	#for loop
		$bigrams[title_array[i]]
		if $bigrams[title_array[i]] == nil		#if no bigram
			$bigrams[title_array[i]] = Hash.new(0) #create new bigram
		end
		$bigrams[title_array[i]][title_array[i+1]] += 1	#2D array
	end
end


#Most Common Word - Method
def mcw(word)
	high = 0
	most_common_key = ""
	$bigrams[word].each do |key, val| #check bigrams with word index
		if val > high 	# "swap" statement if highest vlaue needs replaced
			high = val
			most_common_key = key
		end
	end
	return most_common_key
end


#create title - method
def create_title(starting_word)
	begin															#rescue tool for no more words
		last_title = starting_word
		length = 0
		prev = starting_word
		fix_array = Array.new	#fix array to solve repeating phrases/words probelm

		while length < 20 #max words = 20

			curr = mcw(prev) #next word in sequence

			if(fix_array.include?(curr)) #is the curr word in the fix array
				break
			else
				fix_array.push(curr)	#push new word onto the end of fix array
			end

			if (curr != "" && curr != nil)	#next string has folling word
				length += 1
				last_title << " " #concatonate space
				last_title << curr 	#concatonate curr word
				prev = curr #reset
			else
				length = 21 #no next word
			end
		end #end of while
		return last_title	#return final title
	rescue
		return last_title #return final title in resuce
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
	while (marker == 0) #while marker is zero, ask for a word, gather input
		print "Enter a word [Enter '*q*' to quit]:" #renamed quit command because conflict with user input
		line = STDIN.gets.chomp #user inpui
		if line == "*q*"
			marker = 1	#set marker to 1, exit program
		else
			$GLtitle = ""		#create a blank new title
			$GLcounter = 0	#counter initialized to 0
			puts create_title(line) #calls create_title with line from text file
		end
	end
end

if __FILE__== $0
	main_loop()
end
