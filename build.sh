el_ver='1.4.13'
platform=$1
arch=$2
electron="https://github.com/electron/electron/releases/download/v"$el_ver"/electron-v"$el_ver"-"$platform"-"$arch".zip"

locales='./app/locales'
if [ $platform == 'darwin' ]
then
    locales='./app/Electron.app/Contents/Resources/*lproj'
fi

default_asar='./app/resources/default_app.asar'
if [ $platform == 'darwin' ]
then
    default_asar='./app/Electron.app/Contents/Resources/default_app.asar'
fi

asar_target='./app/resources/app.asar'
if [ $platform == 'darwin' ]
then
    asar_target='./app/Electron.app/Contents/Resources/app.asar'
fi

echo "============== PACKAGING APP =============="

echo
echo "Electron version: "$el_ver
echo "Platform: "$platform
echo "Architecture: "$arch
echo 

echo "Creating asar archive..."
asar pack ./src app.asar

echo "Creating app dir..."
rm -rf ./app
mkdir app

echo "Downloading electron..."
wget -q --show-progress $electron -O electron.zip

echo "Extracting electron..."
unzip electron.zip -d ./app 1>/dev/null

echo "Moviles app files..."
rm -rf $locales
rm ./app/LICENSE* $default_asar
mv app.asar $asar_target

if [ $platform == 'darwin' ]
then
   mv ./app/Electron.app ./app/Pranky.app
fi

echo "Packaging app..."
tar -czf "pranky-"$platform"-"$arch".tar.gz" app

echo "Removing app files..."
rm -rf ./app
rm electron.zip

echo "================== Done. =================="
