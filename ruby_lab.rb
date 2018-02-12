
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Logan Davis
# logand222@gmail.com
#
###############################################################

#Global Variables
$bigrams = Hash.new # The Bigram data structure
$name = "Logan Davis"
$index = 0
$title
$titleList = Array.new

def cleanup_title(songTitle)
#puts songTitle

#Step 1
#looking for the third <SEP> three times and then pritning the songTitle after the third <SEP> found
title = ""
sep_pattern = /<SEP>/

	if songTitle =~ sep_pattern
		title = "#{$'}"
	end

	if title =~ sep_pattern
		title = "#{$'}"
	end

	if title =~ sep_pattern
		title = "#{$'}"
	end


#step2
sf_pattern = /[(\[\{\\\/_\-:"`+=*]|feat./

	if title =~ sf_pattern
		title = "#{$`}"
	end

#step 3
punc_pattern = /[?¿!¡.;&@%#|]/

	if title =~ punc_pattern
		title.gsub!(punc_pattern, "") #replace with empty pattern
	end


#step 5
title.downcase!

return title
#puts title #prints the newest title (testing purposes)
end #end of cleanup_title method

#buildBigram method
def buildBigram(word)
	$titleList.each do |title|
		patt = /#{word}/
		if patt =~ title
			secondWord = "#{$'}"
			#$bigrams = {"#{word}": $index}
		end
		patt2 = / \w* /
		if patt2 =~ secondWord
			killSpaces = "#{$&}"
		end

		patt3 = /\S\w*\S/
		if patt3 =~ killSpaces
			$bigrams["#{$&}"] = $index
			$index += 1
		end
	end
end

# function to process each line of a file and extract the song titles
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
				title = cleanup_title(line)
				#puts title
				$titleList.push(title)
			end
			buildBigram(" love ")
			puts $bigrams.inspect
			#puts $bigrams[keys[0]]
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
end

if __FILE__==$0
	main_loop()
end
