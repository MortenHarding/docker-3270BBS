PLATFORM="$1"

#Remove existing 3270BBS executable
if [  -f "/opt/3270bbs/tsu" ]; then
    rm -f /opt/3270bbs/tsu
fi

#Find latest release
ASSETNAME=$(curl --silent -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/moshix/3270BBS/releases/latest" | jq -r '.assets[] | {name} | select(.name | contains("'$PLATFORM'")) | .[]')

#Download latest release
echo "wget -O /opt/3270bbs/tsu https://github.com/moshix/3270BBS/releases/latest/download/${ASSETNAME}"
wget -q -O /opt/3270bbs/tsu "https://github.com/moshix/3270BBS/releases/latest/download/${ASSETNAME}"
chmod +x /opt/3270bbs/tsu

#Create 3270BBS link if it doesn't exist
if [ ! -f "/opt/3270bbs/3270BBS" ]; then
    echo "*** Creating 3270BBS link ***"
    ln -s /opt/3270bbs/tsu /opt/3270bbs/3270BBS
fi