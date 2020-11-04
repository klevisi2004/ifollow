# Ifollow
# coded by: klevisi2004
# github.com/klevisi2004/ifollow.git



string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"



banner() {
printf "\n"
printf "\e[1;31m               Coded by: klevisi2004 \e[0m\n "
sleep 1.5
printf " \n"
printf " \e[1;31md88b\e[0m\e[1;95m   .d8    .d88b.   .d b.   .d88b.    8.      .8\e[0m\n"
sleep 0.01
printf " \e[1;31m 88 \e[0m\e[1;95m   d8'   d8    8b  88 88  d8    8b   98      8P\e[0m\n"
sleep 0.01
printf " \e[1;31m 88 \e[0m\e[1;95m   88   d8      8b 88 88 d8      8b  98      8P\e[0m\n"
sleep 0.01
printf " \e[1;31m 88 \e[0m\e[1;95m 888888 98      88 88 88 98      8P  98   8  8P\e[0m\n"
sleep 0.01
printf " \e[1;31m 88 \e[0m\e[1;95m   88    98    8P  88 88  98    8P   98 8P98 8P\e[0m\n"
sleep 0.01
printf " \e[1;31m8888\e[0m\e[1;95m   8P      988P    88 88    988P      98P  98P\e[0m\n"
printf "\e\n"
sleep 0.01
printf "\e[1;31m             .::\e[0m\e[1;41mInstagram \e[0m\e[1;45mFollowers\e[0m\e[1;31m::.\e[0m\n"
sleep 1

}



login_user() {


if [[ $user == "" ]]; then
printf "\e[1;31m Login\e[0m\n"
read -p $'\e[0m\e[1;31m Username: \e[0m' user
fi

if [[ -e cookie.$user ]]; then

printf "\e[1;31m Use saved password for \e[0m\e[1;77m %s\e[0m\n" $user

default_use_cookie="Y"

read -p $'\e[1;31m Use it?\e[0m\e[1;95m [Y/n]\e[0m ' use_cookie

use_cookie="${use_cookie:-${default_use_cookie}}"

if [[ $use_cookie == *'Y'* || $use_cookie == *'y'* ]]; then
printf "\e[1;31m Using saved credentials\e[0m\n"
else
rm -rf cookie.$user
login_user
fi


else

read -s -p $'\e[0m\e[1;31m Password: \e[0m' pass
printf "\n"
data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'

IFS=$'\n'

hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

printf "\e[1;31m] Trying to login as\e[0m\e[1;77m %s\e[0m\n" $user
IFS=$'\n'
var=$(curl -c cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq ); 
if [[ $var == "challenge" ]]; then printf "\e[1;92m\n[!] Challenge required\n" ; exit 1; elif [[ $var == "logged_in_user" ]]; then printf "\e[1;92m \n[+] Login Successful\n" ; elif [[ $var == "Please wait" ]]; then echo "Please wait"; fi; 

fi

}




get_following() {

user_id=$(curl -L -s 'https://www.instagram.com/'$user_account'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')

curl -L -b cookie.$user -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/$user_id/following" > $user_account.following.temp


cp $user_account.following.temp $user_account.following.00
count=0

while [[ true ]]; do
big_list=$(grep -o '"big_list": true' $user_account.following.temp)
maxid=$(grep -o '"next_max_id": "[^ ]*.' $user_account.following.temp | cut -d " " -f2 | tr -d '"' | tr -d ',')

if [[ $big_list == *'big_list": true'* ]]; then

url="https://i.instagram.com/api/v1/friendships/6971563529/following/?rank_token=$user_id\_$guid&max_id=$maxid"

curl -L -b cookie.$user -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'  -H "$header" "$url" > $user_account.followers.temp

cp $user_account.following.temp $user_account.following.$count

unset maxid
unset url
unset big_list
else
grep -o 'username": "[^ ]*.' $user_account.following.* | cut -d " " -f2 | tr -d '"' | tr -d ',' | sort > $user_account.following_temp
cat $user_account.following_temp | uniq > $user_account.following_backup
rm -rf $user_account.following_temp

tot_following=$(wc -l $user_account.following_backup | cut -d " " -f1)
printf "\e[1;31m Total Following:\e[0m\e[1;77m %s\e[0m\n" $tot_following
printf "\e[1;31m Saved:\e[0m\e[1;77m %s - following_backup\e[0m\n" $user_account


if [[ ! -d $user_account/raw_following/ ]]; then
mkdir -p $user_account/raw_following/
fi
cat $user_account.following.* > $user_account/raw_following/backup.following.txt
rm -rf $user_account.following.*
break

fi
echo $count
let count+=1

done



}

total_followers() {

printf "\e[1;31m Creating followers list for user\e[0m \e[1;77m%s\e[0m\n" $user_account
printf "\e[1;31m Please wait...\e[0m\n"


user_id=$(curl -L -s 'https://www.instagram.com/'$user_account'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')

curl -L -b cookie.$user -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/$user_id/followers/" > $user_account.followers.temp

cp $user_account.followers.temp $user_account.followers.00
count=0


while [[ true ]]; do
big_list=$(grep -o '"big_list": true' $user_account.followers.temp)
maxid=$(grep -o '"next_max_id": "[^ ]*.' $user_account.followers.temp | cut -d " " -f2 | tr -d '"' | tr -d ',')

if [[ $big_list == *'big_list": true'* ]]; then

url="https://i.instagram.com/api/v1/friendships/$user_id/followers/?rank_token=$user_id\_$guid&max_id=$maxid"

curl -L -b cookie.$user -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'  -H "$header" "$url" > $user_account.followers.temp

cp $user_account.followers.temp $user_account.followers.$count

unset maxid
unset url
unset big_list
else
grep -o 'username": "[^ ]*.' $user_account.followers.* | cut -d " " -f2 | tr -d '"' | tr -d ',' > $user_account.followers_backup

tot_follow=$(wc -l $user_account.followers_backup | cut -d " " -f1)
printf "\e[1;31m Total Followers:\e[0m\e[1;77m %s\e[0m\n" $tot_follow
printf "\e[1;31m Saved:\e[0m\e[1;77m %s.followers_backup\e[0m\n" $user_account
if [[ $user == $user_account ]]; then

if [[ ! -d $user/raw_followers/ ]]; then
mkdir -p $user/raw_followers/
fi

cat $user.followers.* > $user/raw_followers/backup.followers.txt
rm -rf $user.followers.*

break


else
if [[ ! -d $user_account/raw_followers/ ]]; then
mkdir -p $user_account/raw_followers/
fi

cat $user_account.followers.* > $user_account/raw_followers/backup.followers.txt
rm -rf $user_account.followers.*

break

fi

fi

let count+=1

done

}


follow() {

username_id=$(curl -L -s 'https://www.instagram.com/'$user'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')

user_id=$(curl -L -s 'https://www.instagram.com/'$user_account'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')
data='{"_uuid":"'$guid'", "_uid":"'$username_id'", "user_id":"'$user_id'", "_csrftoken":"'$var2'"}'
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
curl -L -b cookie -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/create/$user_id/" 


}


unfollow() {


username_id=$(curl -L -s 'https://www.instagram.com/'$user'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')

user_id=$(curl -L -s 'https://www.instagram.com/'$user_account'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')

data='{"_uuid":"'$guid'", "_uid":"'$username_id'", "user_id":"'$user_id'", "_csrftoken":"'$var2'"}'
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)

check_unfollow=$(curl -L -b cookie -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/destroy/$user_id/" | grep -o '"following": false')
if [[ $check_unfollow == "" ]]; then
printf "\e[1;31m [!] Error\n"
else
printf "\e[1;92mOK\e[0m\n"
fi
}

unfollower() {

user_account=$user
get_following

printf "\e[1;31m Unfollowing all followers from \e[0m\e[1;95m%s ...\e[0m\n" $user_account
printf "\e[1;77m Press \"Ctrl + c\" to stop...\e[0m\n"
sleep 1
while [[ true ]]; do


for unfollow_name in $(cat $user_account.following_backup); do

username_id=$(curl -L -s 'https://www.instagram.com/'$user'' > getmyid && grep -o  'profilePage_[0-9]*.' getmyid | cut -d "_" -f2 | tr -d '"')

user_id=$(curl -L -s 'https://www.instagram.com/'$unfollow_name'' > getunfollowid && grep -o  'profilePage_[0-9]*.' getunfollowid | cut -d "_" -f2 | tr -d '"')


data='{"_uuid":"'$guid'", "_uid":"'$username_id'", "user_id":"'$user_id'", "_csrftoken":"'$var2'"}'
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Unfollowing %s ..." $unfollow_name
check_unfollow=$(curl -s -L -b cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/destroy/$user_id/" | grep -o '"following": false' ) 

if [[ $check_unfollow == "" ]]; then
printf "\n\e[1;31m [!] Error, stoping to prevent blocking\e[0m\n"
exit 1
else
printf "\e[1;95mDone\e[0m\n"
fi

sleep 1
done


done

}

increase_followers() {

printf "\e[1;31m Starting following/unfollowing process\e[0m\n"
printf "\e[1;31m you can increase your followers up to +20 in 1 hour \e[0m\n"
printf "\e[1;77m Press Ctrl + C to stop \e[0m\n"
sleep 3

username_id=$(curl -L -s 'https://www.instagram.com/'$user'' > getid && grep -o  'profilePage_[0-9]*.' getid | cut -d "_" -f2 | tr -d '"')

katyperry="407964088"
selena="460563723"
neymar="26669533"
ariana="7719696"
beyonce="247944034"
cristiano="173560420"
kimkardashian="18428658"
kendalljenner="6380930"
therock="232192182"
kylie="12281817"
jelopez="305701719"
messi="427553890"
nasa="528817151"
gigihadid="12995776"
kingjames="19410587"
selenagomez="460563723"

champagnepapi="14455831"
jlo="305701719"
dualipa="12331195"
mileycyrus="325734299"
shawnmendes="212742998"
katyperry="407964088"
charlieputh="7555881"
lelepons="177402262"
camila_cabello="19596899"
madonna="181306552"
leonardodicaprio="1506607755"
ladygaga="184692323"
taylorswift="11830955"
instagram="25025320"


if [[ ! -e celeb_id ]]; then
printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" $champagnepapi $jlo $dualipa $mileycyrus $shawnmendes $katyperry $charlieputh $lelepons $camila_cabello $madonna $leonardodicaprio $ladygaga $taylorswift $instagram $neymar $katyperry $selena $ariana $beyonce $cristiano $kimkardashian $kendalljenner $therock $kylie $jelopez $messi $nasa $gigihadid $kingjames $selenagomez > celeb_id
fi

while [[ true ]]; do


for celeb in $(cat celeb_id); do

data='{"_uuid":"'$guid'", "_uid":"'$username_id'", "user_id":"'$celeb'", "_csrftoken":"'$var2'"}'
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
printf "\e[1;31m Following process %s ..." $celeb

check_follow=$(curl -s -L -b cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/create/$celeb/" | grep -o '"following": true')

if [[ $check_follow == "" ]]; then
printf "\n\e[1;31m [!] Error\n"
exit 1
else
printf "\e[1;95mDone\e[0m\n"
fi

sleep 2

done
printf "\e[1;77m Sleeping 70 secs...\e[0m\n"
sleep 70
#unfollow
for celeb in $(cat celeb_id); do
data='{"_uuid":"'$guid'", "_uid":"'$username_id'", "user_id":"'$celeb'", "_csrftoken":"'$var2'"}'
hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
printf "\e[1;31m Unfollowign process %s ..." $celeb
check_unfollow=$(curl -s -L -b cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/destroy/$celeb/" | grep -o '"following": false' ) 

if [[ $check_unfollow == "" ]]; then
printf "\n\e[1;31m [!] Error, stoping to prevent blocking\n"
exit 1
else
printf "\e[1;95mDone\e[0m\n"
fi

sleep 2
done
printf "\e[1;92m Sleeping 50 secs...\e[0m\n"
printf "\e[1;77m Press \"Ctrl + c\" to stop starting the following process again \e[0m\n"
sleep 50


done


}


track_unfollowers() {

default_user=$user

 
read -p $'\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Account (leave it blank to use your account): \e[0m' user_account

user_account="${user_account:-${default_user}}"

if [[ -e followers1.$user_account ]]; then

printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Last list found for user \e[0m\e[1;77m%s\e[0m\e[1;31m, creating a new and comparing it\e[0m\n" $user_account
total_followers

cp $user_account.followers_backup followers2.$user_account
unfollowers=$(grep -Fxv -f followers2.$user_account followers1.$user_account)


if [[ $unfollowers != "" ]]; then

printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Unfollowers:\e[0m\n"

grep -Fxv -f followers2.$user_account followers1.$user_account >> $user_account.unfollowers
printf "\e[1;77m\n"
cat $user_account.unfollowers
printf "\e[0m\n"
printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Saved: \e[0m\e[1;31m%s.unfollowers\e[0m\n" $user_account
mv followers2.$user_account followers1.$user_account

else
printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;92m No Unfollower\e[0m\n"
fi


else
#get  followers
printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Creating followers list\e[0m\n"
total_followers
cp $user_account.followers_backup followers1.$user_account
printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Saved!\e[0m\e[1;77m (followers1.%s)\e[0m\n" $user_account
printf "\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;31m Please, run again to track unfollowers\e[0m\n"

fi



}


menu() {

printf "\n"
printf " \e[1;92m 1\e[0m\e[1;31m \e[0m\e[1;31m Increase Followers\e[0m\n"
printf " \e[1;92m 2\e[0m\e[1;31m \e[0m\e[1;31m Activate Unfollower\e[0m\n"
printf "\n"


read -p $' \e[1;95m Choose an option: \e[0m' option

if [[ $option -eq 1 ]]; then
login_user
increase_followers

elif [[ $option -eq 2 ]]; then

login_user
unfollower

else

printf "\e[1;31m[!] Invalid Option!\e[0m\n"
sleep 2
menu

fi
}


banner
menu
