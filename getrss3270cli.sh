PLATFORM="$1"

#Remove existing rss3270cli repo
if [  -f "/opt/rss3270cli/rss3270cli" ]; then
    rm -rf /opt/rss3270cli
fi

#git clone rss3270cli
echo "git clone --depth=1 https://github.com/MortenHarding/rss3270cli.git /opt/rss3270cli"
git clone --depth=1 https://github.com/MortenHarding/rss3270cli.git /opt/rss3270cli

#Find latest release
ASSETNAME=$(curl --silent -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/MortenHarding/rss3270cli/releases/latest" | jq -r '.assets[] | {name} | select(.name | contains("'$PLATFORM'")) | .[]')

#Download latest release
echo "wget -O /opt/rss3270cli/rss3270cli https://github.com/MortenHarding/rss3270cli/releases/latest/download/${ASSETNAME}"
wget -q -O /opt/rss3270cli/rss3270cli "https://github.com/MortenHarding/rss3270cli/releases/latest/download/${ASSETNAME}"

chmod +x /opt/rss3270cli/rss3270cli
