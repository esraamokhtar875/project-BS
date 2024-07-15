#! /usr/bin/bash
let cont=0
let match=0
let connect=0
let coundel=0
let coundeltable=0
# Define the db_menu function
db_menu() {
    select t in Create-Table List-Tables Drop-Table Insert-into-Table Select-From-Table Delete-From-Table Update-Table Back-to-Main-Menu
    do
        case $t in
            'Create-Table')
                read -p "Enter the name of your table with this pattern(A-Za-z]+$): " table
                ct=0
                regxCtable='^[A-Za-z]+$'
	if [[ $table =~ $regxCtable ]]
	then
                for i in $(ls); do
                    if [[ $i == $table ]]; then
                        ct+=1
                    fi
                done

                if [[ ct -gt 0 ]]; then
                    echo "---->This table already exists "
                else
                    touch $table
                fi
                else
                echo "---->invalid pattern of name's table "
                fi
                ;;
            'List-Tables')
                ls
                ;;
            'Drop-Table')
                read -p "Enter the name of the table to delete: " table
                echo "$(ls $path)"
                coundeltable=0
                for i in $(ls $path)
					do
						if [[ $table == $i ]]
						then
						coundeltable+=1
						fi
					done
				if [[ $coundeltable -gt 0 ]]
				then
				     rm $table
				    echo "the table of $table has been deleted."
				else
				   echo " this $table is not found to delet"
				fi
                ;;
	  'Insert-into-Table') 
			    read -p "Enter the name of the table: " table
			    echo "$(ls $path2)"
			    countInsert=0

			    for i in $(ls $path2); do
				if [[ $i == $table ]]; then
				    countInsert+=1
				fi
			    done

			    if [[ $countInsert -gt 0 ]]; then
				# Read the first line of the table to get the column names
				columns=$(head -n 1 "$table")
				column_types=$(sed -n '2p' "$table")

				if [[ -z $columns ]]; then
				    read -p "Insert the name of columns (separated by commas): " columns
				    rejxofcol='^[A-Za-z]+(,[A-Za-z]+)*$'
				    if [[ $columns =~ $rejxofcol ]]; then
					echo "$columns" > "$table"
				    else
					echo "Invalid pattern of column names."
					return
				    fi

				    read -p "Insert the types of columns (e.g., text, number, date separated by commas): " column_types
				    rejxoftypes='^(text|number|date)(,(text|number|date))*$'
				    if [[ $column_types =~ $rejxoftypes ]]; then
					echo "$column_types" >> "$table"
				    else
					echo "Invalid pattern of column types."
					return
				    fi
				fi

				IFS=',' read -r -a columns_array <<< "$columns"
				IFS=',' read -r -a column_types_array <<< "$column_types"

				read -p "Insert values (separated by commas): " values
				IFS=',' read -r -a values_array <<< "$values"

				if [[ ${#columns_array[@]} -ne ${#values_array[@]} ]]; then
				    echo "The number of columns and values do not match."
				    return
				fi

				# Set the first column as the unique column (primary key)
				unique_index=0
				unique_value="${values_array[$unique_index]}"

				# Check for duplicate unique column value
				while IFS=':' read -r -a row; do
				    if [[ "${row[$unique_index]}" == "$unique_value" ]]; then
					echo "Duplicate value for unique column found. Insertion aborted."
					return
				    fi
				done < <(tail -n +3 "$table")

				# Validate and format the data
				for i in "${!columns_array[@]}"; do
				    value="${values_array[$i]}"
				    type="${column_types_array[$i]}"
				    case "$type" in
					"number")
					    if ! [[ $value =~ ^[0-9]+$ ]]; then
						echo "Invalid value for column ${columns_array[$i]}. Expected a number."
						return
					    fi
					    ;;
					"text")
					    if ! [[ $value =~ ^[A-Za-z]+$ ]]; then
						echo "Invalid value for column ${columns_array[$i]}. Expected text."
						return
					    fi
					    ;;
					"date")
					    if ! [[ $value =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
						echo "Invalid value for column ${columns_array[$i]}. Expected a date in YYYY-MM-DD format."
						return
					    fi
					    ;;
					*)
					    echo "Unknown type for column ${columns_array[$i]}."
					    return
					    ;;
				    esac
				done

				# Format the data and append to the table
				row_data=$(IFS=':'; echo "${values_array[*]}")
				echo "$row_data" >> "$table"
				echo "Data inserted successfully."
			    else
				echo "Table $table does not exist."
			    fi

			# Main script
			case $1 in
			    'Insert-into-Table')
				insert_into_table
				;;
			    *)
				echo "Invalid option."
				;;
			esac
			;;
            'Select-From-Table')
                read -p "Enter table name: " table
                if [[ -f $table ]]; then
                    cat $table
                else
                    echo "Table $table does not exist."
                fi
                ;;
          'Delete-From-Table') 

			read -p "Enter table name: " table

			if [[ -f $table ]]; then
			    echo "Choose an option:"
			    echo "1. Delete row"
			    echo "2. Delete column"
			    echo "3. Delete specific data"
			    read -p "Enter your choice: " choice

			    case $choice in
				1)
				    # Delete row
				    read -p "Enter row number to delete (excluding header): " row_num
				    if [[ $row_num -ge 1 ]]; then
					# Adjust row_num to account for header
					row_num=$((row_num + 1))
					sed -i "${row_num}d" $table
					echo "Row $row_num deleted from $table."
				    else
					echo "Invalid row number."
				    fi
				    ;;
				2)
				    # Delete column
				    read -p "Enter column number to delete: " col_num
				    if [[ $col_num -ge 1 ]]; then
					awk -v col=$col_num 'BEGIN {FS=OFS=","} {
					    for (i=col; i<NF; i++) $i=$(i+1);
					    NF--;
					    print
					}' $table > temp && mv temp $table
					echo "Column $col_num deleted from $table."
				    else
					echo "Invalid column number."
				    fi
				    ;;
				3)
				    # Delete specific data
				    read -p "Enter data to delete: " data
				    awk -v data="$data" 'BEGIN {FS=OFS=","} {
					for (i=1; i<=NF; i++) {
					    if ($i == data) $i = "";
					}
					print
				    }' $table > temp && mv temp $table
				    echo "Data '$data' deleted from $table."
				    ;;
				*)
				    echo "Invalid choice."
				    ;;
			    esac
			else
			    echo "Table $table does not exist."
			fi
                      ;;
			 'Update-Table')
                read -p "Enter table name: " table
                if [[ -f $table ]]; then
                    columns=$(head -n 1 "$table")
                    IFS=',' read -r -a columns_array <<< "$columns"
                    read -p "Enter primary key to identify the row to update: " primary_key
                    row_num=$(awk -F':' -v pk="$primary_key" '$1 == pk {print NR}' "$table")
                    if [[ -z $row_num ]]; then
                        echo "Primary key not found."
                        return
                    fi
                    row=$(sed -n "${row_num}p" "$table")
                    IFS=':' read -r -a row_data <<< "$row"
                    for i in "${!columns_array[@]}"; do
                     read -p "Enter new value for ${columns_array[$i]} (or press Enter to keep current value: ${row_data[$i]}): " new_value
                        if [[ -n $new_value ]]; then
                            row_data[$i]=$new_value
                        fi
                    done
                    updated_row=$(IFS=':'; echo "${row_data[*]}")
                    sed -i "${row_num}s/.*/$updated_row/" "$table"
                    echo "Row with primary key $primary_key updated successfully."
                else
                    echo "Table $table does not exist."
                fi
                ;;	
            'Back-to-Main-Menu')
            cd $HOME/DBSQL
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

for i in $(ls $HOME)
do 
	if [[  $i == "DBSQL" ]]
	then
	cont+=1
	fi
done

if [[ $cont -gt 0 ]]
		then
		cd ./DBSQL
		path="$pwd" 
		echo "-------------------------------choose any number"
			select option in create-DB list-DB drop-DB connect-DB exit
			do 
				case $option in
				'create-DB')
					read -p '-------------------------------create your DB : ' schema
					match=0
					regxC='^[a-zA-Z]+[0-9]+$'
					       if [[ $schema =~ $regxC ]]
						then
					for i in `ls $path`
					do
					         if [[ $schema == $i ]] 
					         then
						   match+=1 
					         fi
					done
						if [[ $match -eq 0 ]] 
						         then
							   mkdir $schema
							   else
							   echo "this schema is already found " 
						fi 
						    else 
	echo "invalid pattern of name"
	fi
						 
					;;
				'list-DB')
				echo "-------------------------------list all DB"
					echo $(ls $path)
					;;
				'drop-DB')
				read -p "-------------------------------delet any DB : " del
				 coundel=0
					for i in $(ls $path)
					do
						if [[ $del == $i ]]
						then
						coundel=+1
						fi
					done
					if [[ $coundel -gt 0 ]]
					then
					   rm -r $del
					   echo "---->Database $del has been deleted."
					else
					     echo "---->this DB not found to delet"
					fi
					;;
				'connect-DB')
				read -p "-------------------------------connect your DB : " conn
				connect=0
				for i in $(ls $path)
					do 
						if [[  $i == $conn ]]
						then
						connect+=1
						echo "$conn is connected now"
						fi
					done
					if [[ $connect -gt 0 ]] 
				                then
						cd ./$conn
						db_menu
					else
						echo "this DB is not found "
					fi 
					;;
				'exit')
					break
					;;
				esac
		done
				
else
	mkdir DBSQL
fi
