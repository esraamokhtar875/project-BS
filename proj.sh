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
                read -p "Enter the name of the table with this pattern (^[A-Za-z]+$) : " table
                 regxNtable='^[A-Za-z]+$'
	      if [[ $table =~ $regxNtable ]]
	      then
                if [[ -f $table ]]; then
                    read -p "Insert name of columns of table with this pattern (^[A-Za-z]+$) : " columns
                    regxcol='^[A-Za-z]+$'
	          if [[ $columns =~ $regxcol ]]
	          then
	          
                    read -p "Insert data-type of columns of table string or number: " datatypecol
		         if [[ $datatypecol == "string" ]]
		         then
		          read -p "Insert string values with this pattern (^[A-Za-z]+$) : " values1
		            regxval1='^[A-Za-z]+$'
				if [[ $values1 =~ $regxval1 ]]
				then
			
		                     echo "$columns : $values1" >> $table
		                     else
		                     echo "invalid pattern of string value"
		                     fi
		          elif [[ $datatypecol == "number" ]]
		           then
		            read -p "Insert numerical values with this pattern (^[0-9]+$)  : " values2
		                regxval2='^[0-9]+$'
				if [[ $values2 =~ $regxval2 ]]
				then
		                     echo "$columns : $values2" >> $table
		                     else
		                     echo "invalid pattern of numerical value"
		                     fi
		          else
		          echo "--------error : please enter right datatype >string Or number only-----"
		          fi
		 
		      else
		      echo "invalid pattern of column"
		      fi
                else
                    echo "Table $table does not exist."
                fi
                else
                echo "invalid pattern name of table"
                fi
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
                    read -p "Enter row to delete: " row
                    sed -i "/$row/d" $table
                else
                    echo "Table $table does not exist."
                fi
                ;;
            'Update-Table')
                read -p "Enter table name: " table
                if [[ -f $table ]]; then
                    read -p "Enter row to update: " old_row
                    read -p "Enter new row: " new_row
                    sed -i "s/$old_row/$new_row/" $table
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
