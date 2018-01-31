
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "<firstname> <lastname>"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			# do something for each line
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

def cleanup_title()
	extract()
	eliminate()

def extract(songTitle)
    patt = /<SEP>[\w\s]*$/
    if patt =~ songTitle
        newTitle = "#{$&}"
    end
    secondPatt = /<SEP>/
    if secondPatt =~ newTitle
        finalTitle = "#{$'}"
    end
end

def eliminate(songTitle)
		patt = /<SEP>[\w|\s]((|[|{|\|/|_|-|:|"|`|+|=|\|\ feat.)/
		if patt =~ songTitle
        secondTitle = "#{$}"
    end

    secondPatt = /<SEP>/
    if secondPatt =~ secondTitle
        thirdTitle = "#{$'}"
    end

    thirdPatt = /(\(|\[|\{|\\|\/|\_|\-|\:|\"|\|+|=|*|\ feat.)/
    if thirdPatt =~ thirdTitle
        finalTitle = "#{$`}"
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
