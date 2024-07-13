#! /usr/bin/bash
let cont=0
let match=0
let connect=0

# Define the db_menu function
db_menu() {
    select t in Create-Table List-Tables Drop-Table Insert-into-Table Select-From-Table Delete-From-Table Update-Table Back-to-Main-Menu; do
        case $t in
            'Create-Table')
                read -p "Enter the name of your table: " table
                ct=0
                for i in $(ls); do
                    if [[ $i == $table ]]; then
                        ct+=1
                    fi
                done

                if [[ ct -gt 0 ]]; then
                    echo "This table already exists."
                else
                    touch $table
                fi
                ;;
            'List-Tables')
                ls
                ;;
            'Drop-Table')
                read -p "Enter the name of the table to delete: " table
                rm $table
                ;;
            'Insert-into-Table')
                read -p "Enter the name of the table: " table
                if [[ -f $table ]]; then
                    read -p "Insert name of columns of table: " columns
                    read -p "Insert values: " values
                    echo "$columns : $values" >> $table
                else
                    echo "Table $table does not exist."
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
							   echo "this schema is founded " 
						fi  
					;;
				'list-DB')
				echo "-------------------------------list all DB"
					echo $(ls $path)
					;;
				'drop-DB')
				read -p "-------------------------------delet any DB : " del
					rm -r $del
					;;
				'connect-DB')
				read -p "-------------------------------connect your DB : " conn
				connect=0
				for i in $(ls $path)
					do 
						if [[  $i == $conn ]]
						then
						connect+=1
						echo "$conn will connect now"
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
<<COMMENT
for i in ls 
do
if [[ schema == i ]] 
done
path= cd ../DBSQL 
COMMENT
