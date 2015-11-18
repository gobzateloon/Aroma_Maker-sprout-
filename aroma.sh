#!/bin/bash
 #
 # Copyright © 2014, Thanura Nadun "Teloon" <nadunnew@gmail.com> 
 #
 # Aroma Maker
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
clear
echo -e "\e[42;5m"
echo $'#-----------------------------------------------------------------#' 
echo $'#-----------------------------------------------------------------#' 
echo $'                     _           _     _       ____                '            
echo $'     /\             | |         (_)   | |     / __ \               '   
echo $'    /  \   _ __   __| |_ __ ___  _  __| |    | |  | |_ __   ___    ' 
echo $'   / /\ \ |  _ \ / _  | __/ _ \| |/ _  |    | |  | |  _ \ / _ \    '
echo $'  / ____ \| | | | (_| | | | (_) | | (_| |    | |__| | | | |  __/   '
echo $' /_/    \_\_| |_|\__,_|_|  \___/|_|\__,_|__  _\____/|_| |_|\___|   '
echo $'     /\                                |  \/  |     | |            '
echo $'    /  \   _ __ ___  _ __ ___   __ _   | \  / | __ _| | _____ _ __ '
echo $'   / /\ \ | __/ _ \|  _  _ \ / _    |  | |\/| |/ _  | |/ / _ \ __| '
echo $'  / ____ \| || (_) | | | | | | (_|  |  | |  | | (_| |   <  __/ |   '
echo $' /_/    \_\_| \___/|_| |_| |_|\__,_    |_|  |_|\__,_|_|\_\___|_|   '
echo $'#-----------------------------------------------------------------#' 
echo $'#-----------------------------------------------------------------#' 
echo -e "\e[0m"                                                                    

ini='ini/'
if [ ! -d $ini ]; then mkdir $ini; fi
ini='tools/'
if [ ! -d $ini ]; then mkdir $ini; fi
ini='META-INF/'
if [ ! -d $ini ]; then
mkdir META-INF
mkdir META-INF/com
mkdir META-INF/com/google
mkdir META-INF/com/google/android
mkdir META-INF/com/google/android/aroma
fi
for line in $(cat aroma.rc)
do
  case $line in
    aroma_name=*)  eval $line ;; # beware! eval!
    theme=*)   eval $line ;; # dito!
	logo=*)   eval $line ;; # dito!
	zimage=*)   eval $line ;; # dito!
	govs=*)   eval $line ;; # dito!
	gov_default=*)   eval $line ;; # dito!
    freq=*)   eval $line ;; # dito!
    max_freq=*)   eval $line ;; # dito!
    min_freq=*)   eval $line ;; # dito!
    mods=*)   eval $line ;; # dito!
    *) ;;
   esac
done
echo Kernel_name_with_ver:$aroma_name
rm -r ini/*
echo
echo $'#Mods#'
echo $"=====>Mods_count:$mods"
aromlist_mods="checkbox(\n    \"Select Mods \",\n      \"Please select mods that you want to use in this installation :\",\n    \"@personalize\",\n    \"mods.prop\",  \n"
aromlist_mods="$aromlist_mods \"Mods\",            \"\",                                    2,\n"
for ((  i = 0 ;  i < $mods;  i++  ))
do
  name=`expr mods_$i$'_name'`
  data=`expr mods_$i$'_data'`
  extra=`expr mods_$i$'_extra'`
  path=`expr mods_$i$'_path'`
  defa=`expr mods_$i$'_defa'`
  text=`expr mods_$i$'_text'`
  for line in $(cat aroma.rc)
	do
  	case $line in
	$name=*)   eval $line ;; # dito!
    $data=*)   eval $line ;; # dito!
    $extra=*)   eval $line ;; # dito!
    $path=*)   eval $line ;; # dito!
    $defa=*)   eval $line ;; # dito!
    $text=*)   eval $line ;; # dito!
  	  *) ;;
   	esac
	done
file=`echo $name`
printf -v file "echo $%s" $file
filename=`eval $file`
file=`echo $data`
printf -v file "echo $%s" $file
filedata=`eval $file`
file=`echo $extra`
printf -v file "echo $%s" $file
fileextra=`eval $file`
file=`echo $path`
printf -v file "echo $%s" $file
filepath=`eval $file`
file=`echo $defa`
printf -v file "echo $%s" $file
filedefa=`eval $file`
file=`echo $text`
printf -v file "echo $%s" $file
filetext=`eval $file`
if [ $fileextra == $'yes' ]; then
echo $"=====>copy ini/$filename"
cp extra/$filename ini/$filename
else
echo $"=====>make ini/$filename"
init="#!/system/bin/sh \n \necho \"$filedata\">$filepath"
echo -e $init > ini/$filename
fi
rcount=$i
((rcount++))
if [  $rcount == $mods ]; then
last=""
else
last=","
fi
if [ $filedefa == $'1' ]; then
getdefa=$'0'
rrm=$'remove'
else
getdefa=$'1'
rrm=$'added'
fi
ifcod="$ifcod if\n    file_getprop(\"/tmp/aroma/mods.prop\",\"item.1.$rcount\") == \"$getdefa\"\n     then\n    ui_print(\"-> $filename is $rrm\");\n	run_program(\"/tmp/busybox\",\"cp\",\"tmp/$filename\",\"/system/etc/init.d/$filename\");\nendif;\n"
aromlist_mods="$aromlist_mods \"$filename\",            \"$filetext\",                                    $filedefa$last\n"
perm="$perm set_perm(0, 0, 0777, \"/tmp/$filename\"); \n"
dele="$dele delete(\"/system/etc/init.d/$filename\"); \n"
done
aromlist_mods="$aromlist_mods ); \n" 
echo 
echo $'#Govs#' 
echo $"=====>Govs_count:$govs"
echo $"=====>Default_gov:$gov_default"
aromlist_govs="selectbox(\n    \"Select Default Governor\",\n      \"Please select governor that you want to use in this installation :\",\n    \"@personalize\",\n    \"governor.prop\",  \n"
for ((  i = 0 ;  i < $govs;  i++  ))
do
  name=`expr gov_$i`
  for line in $(cat aroma.rc)
	do
  	case $line in
	$name=*)   eval $line ;; # dito!
  	  *) ;;
   	esac
	done
file=`expr $name`
printf -v file "echo $%s" $file
fileget=`eval $file`
rcount=$i
((rcount++))
if [ ! $gov_default == $fileget ]; then
echo "=====>make ini/$fileget file" 
init="#!/system/bin/sh \n \necho \"$fileget\">/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
echo -e $init > ini/$fileget
perm="$perm set_perm(0, 0, 0777, \"/tmp/$fileget\"); \n"
dele="$dele delete(\"/system/etc/init.d/$fileget\"); \n"
ifcod="$ifcod if\n    file_getprop(\"/tmp/aroma/governor.prop\",\"selected.0\") == \"$rcount\"\n     then\n    ui_print(\"-> $fileget is Default governor\");\n	run_program(\"/tmp/busybox\",\"cp\",\"tmp/$fileget\",\"/system/etc/init.d/$fileget\");\nendif;\n"
else
echo "=====>Skip making ini/$fileget file because its Default_gov" 
fi
if [  $rcount == $govs ]; then
last=""
else
last=","
fi
if [  $gov_default == $fileget ]; then
defa="1"
else
defa="0"
fi
aromlist_govs="$aromlist_govs \"$fileget\",            \"\",                                    $defa$last\n"
done
aromlist_govs="$aromlist_govs ); \n"
echo
echo $'#Freq#' 
echo $"=====>Freq:$freq"
echo $"=====>Default_max_Freq:$max_freq"
aromlist_max="selectbox(\n    \"Select Default Max_freq\",\n      \"Please select Max_freq that you want to use in this kernel :\",\n    \"@personalize\",\n    \"max.prop\",  \n"
for ((  i = 0 ;  i < $freq;  i++  ))
do
  name=`expr freq_$i`
  for line in $(cat aroma.rc)
	do
  	case $line in
	$name=*)   eval $line ;; # dito!
  	  *) ;;
   	esac
	done
file=`expr $name`
printf -v file "echo $%s" $file
fileget=`eval $file`
rcount=$i
((rcount++))
if [ ! $max_freq == $fileget ]; then
echo "=====>make ini/max_$fileget file" 
init="#!/system/bin/sh \n \necho \"$fileget\">/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
echo -e $init > ini/max_$fileget
perm="$perm set_perm(0, 0, 0777, \"/tmp/max_$fileget\"); \n"
dele="$dele delete(\"/system/etc/init.d/max_$fileget\"); \n"
ifcod="$ifcod if\n    file_getprop(\"/tmp/aroma/max.prop\",\"selected.0\") == \"$rcount\"\n     then\n    ui_print(\"-> $fileget is Default max_freq\");\n	run_program(\"/tmp/busybox\",\"cp\",\"tmp/max_$fileget\",\"/system/etc/init.d/max_$fileget\");\nendif;\n"
else
echo "=====>Skip making ini/max_$fileget file because its max_freq" 
fi
if [  $rcount == $freq ]; then
last=""
else
last=","
fi
if [  $max_freq == $fileget ]; then
defa="1"
else
defa="0"
fi
aromlist_max="$aromlist_max \"$fileget\",            \"\",                                    $defa$last\n"
done
aromlist_max="$aromlist_max ); \n"
echo $"=====>Default_min_Freq:$min_freq"
aromlist_min="selectbox(\n    \"Select Default Min_freq\",\n      \"Please select Min_freq that you want to use in this kernel :\",\n    \"@personalize\",\n    \"min.prop\",  \n"
for ((  i = 0 ;  i < $freq;  i++  ))
do
  name=`expr freq_$i`
  for line in $(cat aroma.rc)
	do
  	case $line in
	$name=*)   eval $line ;; # dito!
  	  *) ;;
   	esac
	done
file=`expr $name`
printf -v file "echo $%s" $file
fileget=`eval $file`
rcount=$i
((rcount++))
if [ ! $min_freq == $fileget ]; then
echo "=====>make ini/min_$fileget file" 
init="#!/system/bin/sh \n \necho \"$fileget\">/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"
echo -e $init > ini/min_$fileget
perm="$perm set_perm(0, 0, 0777, \"/tmp/min_$fileget\"); \n"
dele="$dele delete(\"/system/etc/init.d/min_$fileget\"); \n"
ifcod="$ifcod if\n    file_getprop(\"/tmp/aroma/min.prop\",\"selected.0\") == \"$rcount\"\n     then\n    ui_print(\"-> $fileget is Default min_freq\");\n	run_program(\"/tmp/busybox\",\"cp\",\"tmp/min_$fileget\",\"/system/etc/init.d/min_$fileget\");\nendif;\n"
else
echo "=====>Skip making ini/min_$fileget file because its min_freq" 
fi
if [  $rcount == $freq ]; then
last=""
else
last=","
fi
if [  $min_freq == $fileget ]; then
defa="1"
else
defa="0"
fi
aromlist_min="$aromlist_min \"$fileget\",            \"\",                                    $defa$last\n"
done
aromlist_min="$aromlist_min ); \n"
echo
rm aroma-config
echo "#make Aroma-config file#"
echo "=====>logo:$logo"
echo "splash(5000,\"$logo\");" >> aroma-config
echo "=====>theme:$theme"
echo "theme(\"$theme\");" >> aroma-config
echo "=====>Touchconfig set"
echo "calibrate(\"0.9263\",\"21\",\"0.9944\",\"1\",\"yes\");" >> aroma-config
echo "=====>adding main menu"
echo "menubox(
  #-- Title
    \"$aroma_name\",
  
  #-- Sub Title
    \"Please select from the Menu Below to Modify the required features\",
  
  #-- Icon
    \"@apps\",
    
  #-- Will be saved in /tmp/aroma/menu.prop
    \"menu.prop\",
    
     #-------------------------+-----------------[ Menubox Items ]-------------------------+---------------#
     # TITLE                   |  SUBTITLE                                                 |   Item Icons  #
     #-------------------------+-----------------------------------------------------------+---------------#	
	
    \"Kernel Installation\",        \"Kernel Installation with Various Features\",                    \"@install\",      #-- selected = 1
    \"System Info\",                \"Get and show device/partition informations\",                \"@info\",         #-- selected = 2
    \"ChangeLog\",                  \"Kernel ChangeLog\",                                         \"@agreement\",    #-- selected = 3
    \"Quit Install\",               \"Leave Setup\",                                            \"@install\"       #-- selected = 4

);
" >> aroma-config
echo "if prop(\"menu.prop\",\"selected\")==\"2\" then

  #-- Show Please Wait
  pleasewait(\"Getting System Information...\");

  #-- Fetch System Information
  setvar(
    #-- Variable Name
      \"sysinfo\",
    
    #-- Variable Value
      \"<@center><b>Your Device System Information</b></@>\n\n\"+
      
	  \"\n\"+
	  
      \"System Size\t\t: <b><#selectbg_g>\"+getdisksize(\"/system\",\"m\")+\" MB</#></b>\n\"+
        \"\tFree\t\t: <b><#selectbg_g>\"+getdiskfree(\"/system\",\"m\")+\" MB</#></b>\n\n\"+
      \"Data Size\t\t: <b><#selectbg_g>\"+getdisksize(\"/data\",\"m\")+\" MB</#></b>\n\"+
        \"\tFree\t\t: <b><#selectbg_g>\"+getdiskfree(\"/data\",\"m\")+\" MB</#></b>\n\n\"+
      \"SDCard Size\t\t: <b><#selectbg_g>\"+getdisksize(\"/sdcard\",\"m\")+\" MB</#></b>\n\"+
        \"\tFree\t\t: <b><#selectbg_g>\"+getdiskfree(\"/sdcard\",\"m\")+\" MB</#></b>\n\n\"+

      \"\"
  );
  
  #-- Show Textbox
  textbox(
    #-- Title
      \"System Information\",
    
    #-- Subtitle
      \"Current system Information on your Android ONE\",
    
    #-- Icon
      \"@info\",
    
    #-- Text
      getvar(\"sysinfo\")
  );
  
  #-- Show Alert
  alert(
    #-- Alert Title
      \"Finished\",
    
    #-- Alert Text
      \"You will be back to Menu\",
    
    #-- Alert Icon
      \"@alert\"
  );
  
  #-- Back to Menu ( 2 Wizard UI to Back )
  back(\"2\");
  
endif;

if prop(\"menu.prop\",\"selected\")==\"4\" then

#-- Exit
	if
	  confirm(
		#-- Title
		  \"Exit\",
		#-- Text
		  \"Are you sure want to exit the Installer?\",
		#-- Icon (Optional)
		  \"@alert\"
	  )==\"yes\"
	then
	  #-- Exit 
	  exit(\"\");
	endif;

endif;

if prop(\"menu.prop\",\"selected\")==\"3\" then
textbox(
    #-- Title
      \"ChangeLog\",
    
    #-- Subtitle
      \"Whats_up_new\",
    
    #-- Icon
      \"@info\",
    
    #-- Text
      resread(\"changelogs.txt\")
  );
    #-- Show Alert
  alert(
    #-- Alert Title
      \"Finished\",
    
    #-- Alert Text
      \"You will be back to Menu\",
    
    #-- Alert Icon
      \"@alert\"
  );
  
  #-- Back to Menu ( 2 Wizard UI to Back )
  back(\"2\");
  
endif;" >> aroma-config
echo "=====>adding Mod list"
echo -e $aromlist_mods >> aroma-config
echo "=====>adding gov list"
echo -e $aromlist_govs >> aroma-config
echo "=====>adding Max_freq list"
echo -e $aromlist_max >> aroma-config
echo "=====>adding Min_freq list"
echo -e $aromlist_min >> aroma-config
echo "=====>Finishing"
echo "install(
  \"Installing\",
  \"<#999>Now flashing a ...\nPlease Wait...</#>\",
  \"icons/install\"
);

# Set Next Text fo Finish
ini_set(\"text_next\", \"Finish\");

checkviewbox(
  #-- Title
    \"Installation Completed\",
	
  #-- Text
    \"<#selectbg_g><b>Congrats...</b></#>\n\n\"+
    \"<b>$aroma_name</b> has been installed into your device.\n\n\",
    
#-- Icon
    \"@welcome\",

  #-- Checkbox Text
    \"Reboot your device now.\",

  #-- Initial Checkbox value ( 0=unchecked, 1=checked ) -  (Optional, default:0)
    \"1\",

  #-- Save checked value in variable \"reboot_it\" (Optional)
    \"reboot_it\"
);

if
  getvar(\"reboot_it\")==\"1\"
then
  #
  # reboot(\"onfinish\");   - Reboot if anything finished
  # reboot(\"now\");        - Reboot Directly
  # reboot(\"disable\");    - If you set reboot(\"onfinish\") before, use this command to revert it.
  #
  reboot(\"onfinish\");
endif;" >> aroma-config
rm updater-script
echo
echo "#make updater-script file#"
echo "ui_print(\"Preparing installation\");
mount(\"ext4\", \"EMMC\", \"/dev/block/platform/mtk-msdc.0/by-name/system\", \"/system\");
package_extract_dir(\"tools\", \"/tmp\");
set_perm(0, 0, 0777, \"/tmp/mkbootimg\");
set_perm(0, 0, 0777, \"/tmp/unpackbootimg\");
set_perm(0, 0, 0777, \"/tmp/flash_kernel.sh\");
package_extract_dir(\"ini\", \"/tmp\");
show_progress(0.100000, 0);" >> updater-script
echo "=====>adding perms"
echo -e $perm >> updater-script
echo "ui_print(\"*****$aroma_name*****\");
show_progress(0.300000, 0);
run_program(\"/tmp/flash_kernel.sh\");
ui_print(\"Flashed!!\");
delete(\"/tmp/boot.img\");
delete(\"/tmp/mkbootimg\");
delete(\"/tmp/unpackbootimg\");
delete(\"/tmp/flash_kernel.sh\");
ui_print(\"Adding install-recovery.sh and sysint...\");
delete(\"/system/bin/sysint\");
delete(\"/system/etc/install-recovery.sh\");
package_extract_file(\"add_initd.sh\", \"/tmp/add_initd.sh\");
set_perm(0, 0, 0777, \"/tmp/add_initd.sh\");
run_program(\"/tmp/add_initd.sh\");
ui_print(\"-> mounting system...\");
run_program(\"/tmp/busybox\", \"mount\", \"/system\");
set_perm(0, 0, 0777, \"/tmp/busybox\");
set_perm(0, 0, 0777, \"/tmp/busybox.sh\");
ui_print(\"-> Install Busybox\");
run_program(\"/tmp/busybox\",\"chown\",\"-R\",\"0.2000\",\"/system/xbin/busybox\");
run_program(\"/tmp/busybox\",\"chmod\",\"-R\",\"0777\",\"/system/xbin/busybox\");" >> updater-script
echo "=====>adding dels"
echo -e $dele >> updater-script
echo "=====>adding ifcodes"
echo -e $ifcod >> updater-script
echo "show_progress(1,0);
unmount("/system");" >> updater-script
echo
echo "#make $aroma_name-aroma.zip file#"
echo "=====>Create_new zip file"
cp tmp_aroma.zip $aroma_name-aroma.zip
echo "=====>adding files for zip"
zip $aroma_name-aroma.zip ini/*
cp updater-script META-INF/com/google/android/updater-script
zip $aroma_name-aroma.zip META-INF/com/google/android/updater-script
cp aroma-config META-INF/com/google/android/aroma-config
zip $aroma_name-aroma.zip META-INF/com/google/android/aroma-config
cp $logo.png META-INF/com/google/android/aroma/$logo.png
zip $aroma_name-aroma.zip META-INF/com/google/android/aroma/$logo.png
cp changelogs.txt META-INF/com/google/android/aroma/changelogs.txt
zip $aroma_name-aroma.zip META-INF/com/google/android/aroma/changelogs.txt
cp zImage tools/zImage
zip $aroma_name-aroma.zip tools/zImage
echo "install microSD/$aroma_name-aroma.zip" > openrecoveryscript
adb push $aroma_name-aroma.zip /sdcard/$aroma_name-aroma.zip
adb push openrecoveryscript /sdcard/openrecoveryscript
adb shell su -c busybox cp /sdcard/openrecoveryscript /cache/recovery/
adb reboot recovery
echo -e "\e[40;5m"
echo $'                   __               _          _ _                  '
echo $'                  / _\ __ _ _   _  | |__   ___| | | ___             '
echo $'                  \ \ / _  | | | | |  _ \ / _ \ | |/ _ \            '
echo $'                  _\ \ (_| | |_| | | | | |  __/ | | (_) |           '
echo $'                  \__/\__,_|\__, | |_| |_|\___|_|_|\___/            '
echo $'                            |___/                                   '
echo $'                    __                                              '
echo $'                   / _| ___  _ __    __ _ _ __ ___  _ __ ___   __ _ '
echo $'                  | |_ / _ \|  __|  / _  |  __/ _ \|  _   _ \ / _  |'
echo $'                  |  _| (_) | |    | (_| | | | (_) | | | | | | (_| |'
echo $'                  |_|  \___/|_|     \__,_|_|  \___/|_| |_| |_|\__,_|'
echo $'                                                                    ' 
echo -e "\e[0m"  
