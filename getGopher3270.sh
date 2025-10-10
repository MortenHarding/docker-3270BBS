#Remove existing gopher3270 executable
if [  -f "/opt/gopher3270/gopher3270" ]; then
    rm -rf /opt/gopher3270
fi

#git clone gopher3270
echo "git clone --depth=1 https://github.com/ErnieTech101/gopher3270.git /opt/gopher3270"
git clone --depth=1 https://github.com/ErnieTech101/gopher3270.git /opt/gopher3270
chmod +x /opt/gopher3270/gopher3270
