
#!/bin/sh
#

wget -O /var/volatile/tmp/enigma2-plugin-softcams-oscam-emu-levi45_11838-802_all.ipk "https://raw.githubusercontent.com/Ham-ahmed/Others/refs/heads/main/enigma2-plugin-softcams-oscam-emu-levi45_11838-802_all.ipk"
wait
opkg install --force-overwrite /tmp/*.ipk
wait
rm -f /var/volatile/tmp/enigma2-plugin-softcams-oscam-emu-levi45_11838-802_all.ipk
wait
sleep 2;
echo "" 
echo "" 
echo "*********************************************************"
echo "#                   INSTALLED SUCCESSFULLY              #"
echo "*                       ON - Panel                      *"
echo "*                Enigma2 restart is required            *"
echo "*********************************************************"
echo "               UPLOADED BY  >>>>   HAMDY_AHMED           "
sleep 4;
	echo '================================================='
###########################################                                                                                                                  
echo ". >>>>         RESTARING     <<<<"
echo "*********************************************************"
wait
killall -9 enigma2
exit 0