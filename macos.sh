#macos.sh MAC_USER_NAME MAC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN MAC_REALNAME

MAC_USER_NAME=$1
MAC_USER_PASSWORD=$2
VNC_PASSWORD=$3
NGROK_AUTH_TOKEN=$4

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/$MAC_USER_NAME
sudo dscl . -create /Users/$MAC_USER_NAME UserShell /bin/bash
sudo dscl . -create /Users/$MAC_USER_NAME RealName "Real Whatever"
sudo dscl . -create /Users/$MAC_USER_NAME UniqueID 1001
sudo dscl . -create /Users/$MAC_USER_NAME PrimaryGroupID 80
sudo dscl . -create /Users/$MAC_USER_NAME NFSHomeDirectory /Users/tcv
sudo dscl . -passwd /Users/$MAC_USER_NAME $MAC_USER_PASSWORD
sudo dscl . -passwd /Users/$MAC_USER_NAME $MAC_USER_PASSWORD
sudo createhomedir -c -u $MAC_USER_NAME > /dev/null
sudo dscl . -append /Groups/admin GroupMembership $MAC_USER_NAME

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $NGROK_AUTH_TOKEN
ngrok tcp 5900 --region=ap &