#!/usr/bin/env bash
# Customize these values
# [Campsite, Roofed ... ]
DOMAIN=$1
SITE_TYPE=$2
PARK=$3
THIS_YEAR=`date +'%Y'`
ARRIVAL=$THIS_YEAR-$4
NIGHTS=$5
PARTY_SIZE=6
ELECTRICAL_SERVICE='&ElectricalService_incl=on'

# CONSTANTS
BASE_URL=https://$1
AVAILABLE="Available"
COOKIE_PATH=/tmp/Cookie.$1
COOKIE_CONTENT="CookieLocaleName=en-CA"
DATA='resType='$SITE_TYPE'&partySize='$PARTY_SIZE'&equipment=&equipmentSub=&tentPads=&vehicleType=&Accessible_excl=on'$ELECTRICAL_SERVICE'&arrDate='$ARRIVAL'&nights='$NIGHTS'&apId=null&rceId=&bookingDisplay=0'

curl -L -s -c $COOKIE_PATH $BASE_URL/$PARK?List --cookie $COOKIE_CONTENT &>-

RESULT=$(curl $BASE_URL'/ResInfo.ashx' -H 'Origin: '$BASE_URL -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: '$BASE_URL/$PARK'?List' -H 'Connection: keep-alive' --data $DATA --compressed --cookie $COOKIE_PATH --cookie $COOKIE_CONTENT -s)
RESULT=$(curl $BASE_URL'/view.ashx?async=true&sort=null&nav=undefined&selectedSitesOnly=false&selectedSites=' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: '$BASE_URL/$PARK'?List' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7' --compressed --cookie $COOKIE_PATH --cookie $COOKIE_CONTENT -s| grep -e "<img alt=\"$AVAILABLE\"")
if [ $? -eq 0 ]; then
	SITE=$(echo $RESULT | sed -e 's/<[^>]*>/|/g' | sed -E 's/\|+/, /g')
	osascript -e "display notification \"Found a site on $ARRIVAL $SITE$PARK!\" with title \"Notification\""
	say Site found in $PARK at $ARRIVAL
fi

