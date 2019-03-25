## 11/03/2018, 18/03/2019
## abruggem@uni-koeln.de
## Praat 6.0.22

## input1: Praat TextGrid files (assumin a tier 1 with syll, tier 2 with word and tier 3 with phrase)
## input2: Praat pitch files
## TextGrid and Pitch files in same directory

## Upon running this script a form will prompt for the following info:
## - path: directory that contains Pitch and TextGrid files (assumes they are in same directory)
## - tier: which tier's units do you want to normalise over (e.g. Tier 1: syllables, Tier 2: words)
## - nof extraction points: how many measurement points per unit (e.g. 10 per syllable, 20 per word)

## output: textfile with prespecified number of pitch measurement points per word
## pitch measurements in Hertz as well as semitones (relative to 100 Hz)

# delete earlier output files
deleteFile: "/Users/Anna/Desktop/hungtest/syllcontour.txt"
deleteFile: "/Users/Anna/Desktop/hungtest/phrasecontour.txt"

# initiate new output files with headers
fileappend syllcontour.txt filename time point wordno word wordpoint ST hz'newline$'
fileappend phrasecontour.txt filename phrasedur time point ST hz'newline$'

# FORM for user input
form User input 
	sentence path /Users/Anna/Desktop/hungtest/ex_hung/
	integer tier_with_syllables 1
	integer nof_extraction_points_syll 10
	integer nof_extraction_points_phrase 60
endform

		# rename variables
		b = 'tier_with_syllables'
		c = 'nof_extraction_points_syll'
		d = 'nof_extraction_points_phrase'

		Create Strings as file list: "tgridFileObj", "'path$'*.TextGrid"
		nof_tgrid = Get number of strings
	
			for k from 1 to nof_tgrid

				selectObject ("Strings tgridFileObj")
				current_file$ = Get string: 'k'
				name_prefix$ = current_file$ - ".TextGrid"
				word$ = left$(name_prefix$, 6)

				Read from file: "'path$''current_file$'"
				Rename: "selected_tgrid"
				
				z = Get number of intervals: b
				totaltp = z * c
				phrasestart = Get starting point: 1, 2
				phraseend = Get starting point: 1, z
				phrasedur = phraseend - phrasestart

				# sanity check if needed
				# appendInfoLine: "File 'name_prefix$' starts at 'phrasestart:2' and ends at 'phraseend:2'"

				# initialise counter of non-empty intervals encountered
				wordcount = 0
				# initialise counter of measurement points
				pointcountsyll = 0
				pointcountphrase = 0


				########################################
				########################################
				### syllable-normalised contours
				########################################
				########################################

				# loop through all intervals on relevant tier
				for i from 1 to z
					selectObject: "TextGrid selected_tgrid"
					word$ = Get label of interval: b, i

					intstart = Get starting point: b, i
					intend = Get end point: b, i
					intdur = intend - intstart

					# determine duration of each equal part
					intchunk = intdur / c

					# get absolute time values for each of the chunk's starting points
					for j from 1 to c
						unit'j' = intstart + (intchunk * j)
					endfor

					Read from file: "'path$''name_prefix$'.Smooth"

					####### extract pitch measurements
					####### only for non-empty intervals

					if word$ <> ""
						wordcount = wordcount + 1

						for m from 1 to c
							pointcountsyll = pointcountsyll + 1
							selectObject: "Pitch 'name_prefix$'"
							st = Get value at time: unit'm', "semitones re 100 Hz", "Linear"
							hz = Get value at time: unit'm', "Hertz", "Linear"
							timem = unit'm'
	
							fileappend syllcontour.txt 'name_prefix$' 'timem:4' 'pointcountsyll' word'wordcount' 'word$' 'm' 'st:2' 'hz:2''newline$'
						endfor
					endif

				#for i from 1 to z (nof_intervals tier b)
				endfor

					########################################
					########################################
					### phrase-normalised contours
					########################################
					########################################

					# determine duration of each equal part
					phrasechunk = phrasedur / d

					# get absolute time values for each of the chunk's starting points
					for r from 1 to d
						unit'r' = phrasestart + (phrasechunk * r)
					endfor

					Read from file: "'path$''name_prefix$'.Smooth"

					####### extract pitch measurements
					for n from 1 to d
						pointcountphrase = pointcountphrase + 1
						selectObject: "Pitch 'name_prefix$'"
						st = Get value at time: unit'n', "semitones re 100 Hz", "Linear"
						hz = Get value at time: unit'n', "Hertz", "Linear"
						timen = unit'n'
	
						fileappend phrasecontour.txt 'name_prefix$' 'phrasedur:4' 'timen:4' 'pointcountphrase' 'st:2' 'hz:2''newline$'
					endfor

				# pitch selected
				Remove

#for k from 1 to nof_tgrid
endfor

			
select all
Remove

appendInfoLine: "all done"