#!/bin/bash
#!/usr/bin/perl

#####Prequisites
#pishring in directory ~/bin/pishrink.sh

DATUM=`date +%d_%m_%Y`

##### Config
DIR="/home/pi/Skripte/Test1"
#DIR="/mnt/yourdirectory"
NAME="test$DATUM"

#####system-date
ENDING=".txt"
i=0
######icons
HAKEN=""["\033[1;32m\xe2\x9c\x85\033[0m""]"
KREUZ=""["\033[1;31m\xe2\x9d\x8c\033[0m""]"
WARN=""["\033[1;33m!!!\033[0m""]"

#####abfrage der Speichergröße - user output
liste=$(df -hT)
echo "$liste"

#####abfrage lokaler Speichergröße
lsumkblsize=$(df -l | grep /| tr -s ' '| cut -d ' ' -f 2)
###local partitionsgröße addiert
sumkblsize=$(awk '{sum+=$1}END{print sum}' <<<"$lsumkblsize")
sumgblsize=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$sumkblsize")

sumkblsizeondrive=$(awk '{sumgb=$1*1.05}{print int(sumgb)}' <<<"$sumkblsize")
sumgblsizeondrive=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$sumkblsizeondrive")

###local used von partition addiert
lsumkblused=$(df -l | grep /| tr -s ' '| cut -d ' ' -f 3)
sumkblused=$(awk '{sum+=$1}END{print sum}' <<<"$lsumkblused")
sumgblused=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$sumkblused")

#####cifs laufwerk freier speicher
sumkbcifsfree=$(df -T | grep cifs| tr -s ' '| cut -d ' ' -f 5)
sumgbcifsfree=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$sumkbcifsfree")

#####2x größe des images benötigt + used local*1.05
zweifachsumkblsize=$(awk '{sumgb=$1*2.1}{print int(sumgb)}' <<<"$sumkblsize")
zweifachsumgblsize=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$zweifachsumkblsize")
###used local *1.05
sumkblusedondrive=$(awk '{sumgb=$1*1.05}{print int(sumgb)}' <<<"$sumkblused")
sumgblusedondrive=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$sumkblusedondrive")
###gesamtspeicher benötigt on drive
let gesamtspeicherkbondrive=$zweifachsumkblsize+$sumkblusedondrive
gesamtspeichergbondrive=$(awk '{sumgb=$1/1048576}{print sumgb}' <<<"$gesamtspeicherkbondrive")

echo "----------------------------"
echo "	" "	"	"	" "	" Size On Drive
echo local Size "	""$sumgblsize" gb "	" "$sumgblsizeondrive" gb
echo local Used "	""$sumgblused" gb "	" "$sumgblusedondrive" gb
echo Cifs Free "	""$sumgbcifsfree" gb "	"
echo "----------------------------"

#####Speicherabfrage
if [ "$sumkbcifsfree" -gt "$gesamtspeicherkbondrive" ]
	then
		echo "Genug Speicher vorhanden um das Backup zu schreiben."
		echo "----------------------------"
	else
		echo -e $HAKEN"Es ist nicht genug Speicher vorhanden um das Backup durchführen zu können. Bitte mehr Speicherplatz zur Verfügung stellen!"
		read
		exit
fi

##### Abfrage ob Datei schon vorhanden im Verzeichnis
FILEINDIR=$(ls ${DIR} | grep ${NAME})

if [ "$FILEINDIR" = "" ]
	then
		echo "Es ist von heute noch keine Backup Datei vorhanden."
	else
		echo "Es ist schon ein Backup von heute '$DATUM' vorhanden. Soll das neue image umbenannt werden?[y/n]"
		read overwrite
		
			if [ "$overwrite" == "y" ]
				then
					echo "----------------------------"
					echo "bitte image umbenennen"
					echo "$NAME"
					read NAME
					#let i=$i+1
				else
					echo -e $WARN"bitte manuell löschen"
				exit
			fi

fi

#echo "$i"

### parameter für die optionen 
echo "----------------------------"
echo "Soll ein Backup erstellt und verkleinert werden [y/n]?"
read backup


if [ "$backup" == "y" ]
	then
		echo "Soll das RAW-image (unkomprimiert) gelöscht werden? [y/n]"
		read loeschen
		echo "----------------------------"
		
		echo -e $HAKEN"Es wird ein Backup erstellt und verkleinert."
		#sudo dd if=/dev/sda of=${DIR}/rasberrypi4_img_raw.img bs=4M status=progress
		#sudo ~/bin/pishrink.sh ${DIR}/rasberrypi4_img_raw.img ${DIR}/rasberrypi4_img_small_${DATUM}.img
		#sleep 30
		sudo touch ${DIR}/${NAME}${ENDING}
		sudo cp ${DIR}/${NAME}${ENDING} ${DIR}/Test2/${NAME}_small${ENDING}
		echo -e $HAKEN"Das Backup wurde ausgeführt"

		if [ "$loeschen" == "n" ]
			then
				echo -e $WARN"Das RAW Image wurde NICHT gelöscht! Bitte den Speicherplatz überprüfen!"
			else
				# sudo rm ${DIR}/rasberrypi4_img_raw.img
				echo -e $HAKEN"Das RAW Image wird gelöscht"
		fi
		
	else
		echo -e $KREUZ"Abbruch der PC wird nicht gebackupt!"
fi
read
