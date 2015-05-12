REM SCRIPT D'AUTOMATISATION D'AUDIT SERVER LINUX - @bpoinsot
@ECHO OFF
CLS


REM INFORMATIONS SAISIES PAR L'UTILISATEUR
SET /P IP="Adresse IP : "
SET /P PORT="Port SSH : "
SET /P USER="User SSH : "
SET /P PSWD="Pswd SSH : "


REM CRÉATION DE L'HORODATAGE
SET HEURES=%TIME:~0,2%
IF "%HEURES:~0,1%" == " " SET HEURES=0%HEURES:~1,1%
SET MINUTES=%TIME:~3,2%
IF "%MINUTES:~0,1%" == " " SET MINUTES=0%MINUTES:~1,1%
SET SECONDES=%TIME:~6,2%
IF "%SECONDES:~0,1%" == " " SET SECONDES=0%SECONDES:~1,1%
SET ANNEE=%date:~-4%
SET MOIS=%date:~3,2%
IF "%MOIS:~0,1%" == " " SET MOIS=0%MOIS:~1,1%
SET JOUR=%date:~0,2%
IF "%JOUR:~0,1%" == " " SET JOUR=0%JOUR:~1,1%
SET HORODATAGE=%ANNEE%-%MOIS%-%JOUR%-%HEURES%H%MINUTES%
SET RAPPPORT=%IP%-%HORODATAGE%.txt


REM CREATION DU FICHIER CONTENANT LES COMMANDES A EXECUTER SUR LE SERVEUR DISTANT
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" > audit.sh
@ECHO echo -e "\nHOSTNAME :" >> audit.sh
@ECHO hostname >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nESPACE DISQUE :" >> audit.sh
@ECHO df -h >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nMEMOIRE :" >> audit.sh
@ECHO free -h >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nUPTIME :" >> audit.sh
@ECHO uptime >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nINSTANTANE TOP :" >> audit.sh
@ECHO top -b -n 1 >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nPAQUETS DISPONIBLES A LA MISE A JOUR :" >> audit.sh
@ECHO apt-get --just-print upgrade >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nEXECUTION DE MySQLTuner :" >> audit.sh
@ECHO wget -q https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl >> audit.sh
@ECHO perl ./mysqltuner.pl >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh
@ECHO echo -e "\nFIN DE L'AUDIT DE LA MACHINE %IP%" >> audit.sh
@ECHO echo -e "\n----------------------------------------------------------------------------------------------------" >> audit.sh


REM VÉRIFICATION DE LA PRÉSENCE DE PLINK.EXE DANS LE RÉPERTOIRE COURANT SINON ON 
REM LE TÉLÉCHAGE DEPUIS HTTP://THE.EARTH.LI/~SGTATHAM/PUTTY/LATEST/X86/PLINK.EXE
REM GRACE A L'OUTIL NATIF WINDOWS BITS
IF NOT EXIST plink.exe (
  ECHO L'OUTIL "plink.exe" EST ABSENT DU REPERTOIRE COURANT. 
  ECHO LIEN : http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
  PAUSE
  EXIT
)


REM LANCEMENT DES COMMANDES liées à L'AUDIT EN MODE BAVARD (-v)
@ECHO LANCEMENT DE L'AUDIT DU SERVEUR %IP% @ %HORODATAGE% > %RAPPPORT%
plink.exe -ssh -batch -v -l %USER% -P %PORT% -pw %PSWD% %IP% -m audit.sh >> %RAPPPORT%


REM AUDIT terminé, ON LANCE TROIS BEEPS (ALT + 0 + 0 + 7) POUR prévenir ^^
ECHO 
ECHO 
ECHO 
