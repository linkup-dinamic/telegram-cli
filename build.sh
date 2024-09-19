apt-get update
apt-get upgrade
apt-get install make git zlib1g-dev libssl-dev gperf php-cli cmake g++
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

mkdir dist
dpkg-deb --build debian-package dist

rm debian-package/opt/telegram-cli/profile.conf
