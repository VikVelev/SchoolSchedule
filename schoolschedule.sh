#!/bin/bash

#Initializing
alias say='xcowsay' #add arguments here
file="/home/mrtroll/Bash_Training/bashhelloworld.sh" #should be csv, external data sorce not implemented yet
now=`date +%s` #storing the hour when this is opened, for some reason
#hardcoded db
#gotta add the whole week
hours=("ИТ" "ИТ" "МАТ" "МАТ" "АЕ" "БИОЛОГИЯ" "НЕ" "НЕ")
rooms=("Shannon" "Shannon" "403" "403" "403" "403" "307" "304")
#can be used will all schedules \/
hours_hrs=("07:30" "08:10" "09:00" "9:50" "10:50" "11:40" "12:30" "13:15" "14:10" "00:00")
brakes_end=("08:20" "09:10" "10:10" "11:00" "11:50" "12:35" "13:30")
#hardcoded db end
currenthour=0

hash xcowsay 2>/dev/null || { echo >&2 "This requires xcowsay but it's not installed. Install it and try again. Aborting."; exit 1; }

if [ -r $file -a -f $file ]; then
     echo "Reading from this $file.."
     #planning to read the schedule from a file, atm does nothing
     sleep 1
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

xcowsay "Текущ час: ${hours[$currenthour + 1]}, в стая ${rooms[$currenthour + 1]}." --at=50,50 -t 60 &
echo "Текущ час: ${hours[$currenthour + 1]}, в стая ${rooms[$currenthour + 1]}."

while true; do #printing, looping
    if [ `date +%H:%M` = ${hours_hrs[$currenthour + 1]} ]; then
        if [ `date +%H:%M` < ${brakes_end[$currenthour - 1]} ]; then
            xcowsay "В междучасие си! Следващият ти час е ${hours[$currenthour]}. В стая ${rooms[currenthour +  1]}." --at=50,50 -t 60 &        
            echo "В междучасие си! Следващият ти час е ${hours[$currenthour]}. В стая ${rooms[currenthour +  1]}."
        else
            xcowsay "Текущ час: ${hours[$currenthour]}. $(($currenthour + 1)) подред. В стая ${rooms[$currenthour + 1]}." --at=50,50 -t 60 &
            echo "Текущ час: ${hours[$currenthour]}. $(($currenthour + 1)) подред. В стая ${rooms[$currenthour + 1]}."
            let currenthour+=1
            sleep 60 #cheking every minute
        fi
    else
        echo "В час си."
        sleep 60 #checking every minute
    fi
done