#!/bin/sh
PLATFORM="$1"

#Remove existing 3270BBS executable
if [  -f "/opt/3270bbs/tsu" ]; then
    rm -f /opt/3270bbs/tsu
fi

#Find latest release
ASSETNAME=$(curl --silent -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/moshix/3270BBS/releases/latest" \
  | jq -r --arg platform "$PLATFORM" \
    '.assets[] | select(.name | contains($platform)) | .name')

#Download latest release
for ASSET in ${ASSETNAME}; do
    case "$ASSET" in
        3270BBS*)
            echo "Downloading ${ASSET} -> /opt/3270bbs/tsu"
            wget -q -O /opt/3270bbs/tsu "https://github.com/moshix/3270BBS/releases/latest/download/${ASSET}"
            chmod +x /opt/3270bbs/tsu
            ;;
        web3270*)
            echo "Downloading ${ASSET} -> /opt/3270bbs/web3270"
            wget -q -O /opt/3270bbs/web3270 "https://github.com/moshix/3270BBS/releases/latest/download/${ASSET}"
            chmod +x /opt/3270bbs/web3270
            ;;
    esac
done

