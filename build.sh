set -e

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y make git zlib1g-dev libssl-dev gperf php-cli cmake g++
git clone https://github.com/tdlib/td.git
cd td
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib ..
cmake --build . --target install
cd ..
cd ..

cp td/tdlib/lib/libtdjson.so debian-package/opt/telegram-cli/

cat > debian-package/opt/telegram-cli/profile.conf << EOF
[DEFAULT]
PHONE_NUMBER=
API_ID=$(echo $API_ID)
API_HASH=$(echo $API_HASH)
EOF

cat > debian-package/DEBIAN/control << EOF
Package: telegram-cli
Version: 0.1-0
Maintainer: Linkup
Architecture: $(dpkg --print-architecture)
Description: Telegram Client for CLI
Depends: python3
EOF

mkdir dist
dpkg-deb --build debian-package dist

rm debian-package/opt/telegram-cli/profile.conf
