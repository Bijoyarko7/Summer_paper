* RUN all the do-files

cd ".\Blanchard (2019)"
do "Run Blanchard 2019"

cd "..\CRSP"
do "Procedure_CRSP_replication"

cd "..\..\LT Inflation Exp"
do "LT Inflation Exp"

cd "..\MSPD"
do "Procedure_MSPD_replication"
cd "..\"
do "Procedure_MSPD_exanterealrate"

clear all
