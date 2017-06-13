#!/bin/bash

#Initializing
cowsay_img="Images/Main.png"
#TODO Add different images for each alert.

file_Mon="Schedule/Monday"
file_Tue="Schedule/Tuesday"
file_Wed="Schedule/Wednesday"
file_Thur="Schedule/Thursday"
file_Fri="Schedule/Friday"
files=($file_Mon $file_Tue $file_Wed $file_Thur $file_Fri)

hours_hrs=(730 810 900 950 1050 1140 1230 1315 1410)
brakes_end=(820 910 1010 1100 1150 1235 1330)

schedule=( )
currenthour=0
currentday=`date +%u`

state="Не в час"

(( currentday -= 1 ))

hash xcowsay 2>/dev/null || { echo >&2 "This requires xcowsay but it's not installed. Install it and try again. Aborting."; exit 1; }

#Preparation, Loading.
counter=0
while [ $counter -le 7 ]; do #намира сегашния час и NE BACHKA # REWRITE
    if [ `date +%k%M` -gt ${hours_hrs[counter]} -a `date +%k%M` -lt ${hours_hrs[counter+1]} ]; then 
        currenthour=$counter
        if [ `date +%k%M` -lt ${brakes_end[currenthour - 1]} -a `date +%k%M` = ${hours_hrs[currenthour + 1]} ]; then
            state="Не в час"
        else
            state="В час"
        fi            
    fi
    let  counter+=1
    if [ $currenthour -eq 7 ]; then
        xcowsay "Не си в даскало." --at=50,50 -t 60 --image=$cowsay_img --cow-size=med &
        echo "Not in school right now."
        exit 0
    fi
done

if [ -f ${files[currentday]} -a -r ${files[currentday]} ]; then #Проверява дали има и дали може да чете файловете за програмата
    echo "Reading from ${files[currentday]}.."
    linecounter=0
    while read -r LINE || [[ -n $LINE ]]; do
        schedule[linecounter]=$LINE
        let linecounter+=1
    done < ${files[currentday]}
    sleep 1
else
    mkdir Schedule
    cd Schedule
    touch Monday, Tuesday, Wednesday, Thursday, Friday
    cd ..
    echo "There were no schedule files found, or I do not have permission to access them. Here generated some empty for you. Go fill them up and then come back."
    exit 0
fi

#Program starting
xcowsay "Текущ/Следващ час: ${schedule[$currenthour]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}." --at=50,50 -t 60 --image=$cowsay_img
echo  "Текущ час: ${schedule[$currenthour]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}."

while true; do #printing, looping#TODO LOGICS
    if [ `date +%k%M` -lt ${brakes_end[currenthour - 1]} ]; then
        xcowsay  "В междучасие си! Следващият ти час е ${schedule[$currenthour]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}." --at=50,50 -t 60 --image=$cowsay_img &        
        echo "В междучасие си! Следващият ти час е ${schedule[$currenthour]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}."
        #check every minute if you're out of the междучасие
    else
        xcowsay "В час си!" --at=50,50 -t 60 --image=$cowsay_img &
        echo "В час си."
        sleep 60
    fi

    if [ `date +%H:%M` = ${hours_hrs[$currenthour + 1]} ]; then   
        xcowsay "Текущ час: ${schedule[$currenthour]}. $(($currenthour + 1)) подред. В стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}." --at=50,50 -t 60 --image=$cowsay_img &
        echo "Текущ час: ${hours[$currenthour]}. $(($currenthour + 1)) подред. В стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}."
        let currenthour+=1
        sleep 60 #cheking every minute
    fi
done
