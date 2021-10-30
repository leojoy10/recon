#sql-----------------------------------------------------------------------------------------





sql(){

mkdir results/sql

#Exploit
python3 ~/tools/sqlmap-dev/sqlmap.py -m sql.txt --batch | tee sql-result

#move
mv sql-result results/sql

}





#sql-----------------------------------------------------------------------------------------