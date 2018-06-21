#!/usr/bin/env bash
COOKIE_PATH=/tmp/Cookie.reservation.pc.gc.ca
COOKIE_CONTENT="CookieLocaleName=en-CA"
PARK=Banff
ARRIVAL=2018-08-01
NIGHTS=1
AVAILABLE="Available"

curl -s --dump-header $COOKIE_PATH https://reservation.pc.gc.ca/$PARK?List --cookie $COOKIE_CONTENT &>-
RESULT=$(curl 'https://reservation.pc.gc.ca/ResInfo.ashx' -H 'Origin: https://reservation.pc.gc.ca' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: https://reservation.pc.gc.ca/$PARK?List' -H 'Connection: keep-alive' --data 'resType=Campsite&partySize=2&equipment=&equipmentSub=MediumTent&tentPads=&vehicleType=&Accessible_excl=on&ElectricalService_incl=on&arrDate='$ARRIVAL'&nights='$NIGHTS'&apId=null&rceId=&bookingDisplay=0' --compressed --cookie $COOKIE_PATH --cookie $COOKIE_CONTENT -s)
RESULT=$(curl 'https://reservation.pc.gc.ca/view.ashx?async=true&sort=null&nav=undefined&selectedSitesOnly=false&selectedSites=' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: https://reservation.pc.gc.ca/$PARK?List' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7' --compressed --cookie $COOKIE_PATH --cookie $COOKIE_CONTENT -s| grep -e "<img alt=\"$AVAILABLE\"")
if [ $? -eq 0 ]; then
	SITE=$(echo $RESULT | sed -e 's/<[^>]*>/|/g' | sed -E 's/\|+/, /g')
	osascript -e "display notification \"Found a site on $ARRIVAL $SITE$PARK!\" with title \"Notification\""
	say Site found in $PARK at $ARRIVAL
fi
