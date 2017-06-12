#!/bin/bash

#Initializing
file_Mon="Schedule/Monday"
file_Tue="Schedule/Tuesday"
file_Wed="Schedule/Wednesday"
file_Thur="Schedule/Thursday"
file_Fri="Schedule/Friday"
files=($file_Mon $file_Tue $file_Wed $file_Thur $file_Fri)

hours_hrs=("07:30" "08:10" "09:00" "9:50" "10:50" "11:40" "12:30" "13:15" "14:10" "00:00")
brakes_end=("08:20" "09:10" "10:10" "11:00" "11:50" "12:35" "13:30")

schedule=( )
currenthour=0
currentday=`date +%u`
(( currentday -= 1 ))

hash xcowsay 2>/dev/null || { echo >&2 "This requires xcowsay but it's not installed. Install it and try again. Aborting."; exit 1; }

if [ -f ${files[currentday]} -a -r ${files[currentday]} ]; then
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
    echo "There were no schedule files found, or I do not have permission to access them. Here generated some empty for you."
fi

counter=0
while [ $counter -le ${#hours[@]} ]; do #намира сегашния час и бачка
    if [ $`date +%H:%M` > ${hours_hrs[$counter]} -a $`date +%H:%M` < ${hours_hrs[counter+1]} ]; then 
        currenthour=$counter         
    fi
    let  counter+=1
    if [ $currenthour -eq ${#hours[@]} ]; then
        xcowsay "Не си в даскало." --at=50,50 -t 60 &
        echo "Not in school right now."
        exit 1
    fi
done

xcowsay "Текущ час: ${schedule[$currenthour + 1]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}." --at=50,50 -t 60 &
echo  "Текущ час: ${schedule[$currenthour + 1]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}."

while true; do #printing, looping
    if [ `date +%H:%M` = ${hours_hrs[$currenthour + 1]} ]; then
        if [ `date +%H:%M` < ${brakes_end[$currenthour - 1]} ]; then
            xcowsay  "В междучасие си! Следващият ти час е ${schedule[$currenthour + 1]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}." --at=50,50 -t 60 &        
            echo "В междучасие си! Следващият ти час е ${schedule[$currenthour + 1]}, в стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}."
            sleep 60 #check every minute if you're out of the междучасие
        else
            xcowsay "Текущ час: ${schedule[$currenthour]}. $(($currenthour + 1)) подред. В стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}." --at=50,50 -t 60 &
            echo "Текущ час: ${hours[$currenthour]}. $(($currenthour + 1)) подред. В стая ${schedule[$currenthour + ((${#schedule[@]}/2)) + 1]}."
            let currenthour+=1
            sleep 60 #cheking every minute
        fi
    else
        echo "В час си."
        sleep 60 #checking every minute
    fi
done
