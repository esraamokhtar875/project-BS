#! /usr/bin/bash
let cont=0
let match=0
let connect=0
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
