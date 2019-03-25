form User input 
	sentence path /Users/Anna/Desktop/hungtest/ex_hung/
endform


Create Strings as file list: "pitchFileObj", "'path$'*.Pitch"
nof_pitch = Get number of strings
	
			for k from 1 to nof_pitch
				selectObject ("Strings pitchFileObj")
				current_file$ = Get string: 'k'
				name_prefix$ = current_file$ - ".Pitch"

				Read from file: "'path$''current_file$'"
				Interpolate
				Smooth: 15
				Save as text file: path$+name_prefix$+".Smooth"

			endfor

select all
Remove

appendInfoLine: "all smoothed"
