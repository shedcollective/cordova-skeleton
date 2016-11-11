if [[ "$1" != "ios" && "$1" != "android" ]]; then

    echo ""
    echo ""
    echo "Specify a valid platform to build for."
    echo "Valid targets are: ios, android"
    echo ""
    echo ""

elif [[ "$2" != "dev" && "$2" != "prod" && "$2" != "stage" ]]; then

    echo ""
    echo ""
    echo "Specify a valid environment to build for."
    echo "Valid targets are: dev, prod, stage"
    echo ""
    echo ""

else

    # Check a version number has been specified if building for prod or stage
    if [[ "$2" = "prod" || "$2" = "stage" ]]; then
        if [ "$3" = "" ]; then

            echo ""
            echo ""
            echo "Version number must be specified when building for $2"
            echo ""
            echo ""
            exit

        fi
    fi

    # Prepare the source
    echo "Preparing source files..."
    bower install || exit
    gulp build || exit

    # Start from fresh
    echo "Clearing www directory..."
    rm -rf ./dist/www
    mkdir -p ./dist/www || exit
    rm -rf ./dist/icons-splash
    mkdir -p ./dist/icons-splash || exit

    # Copy the source
    echo "Copying source files..."
    cp -R ./src/app/* ./dist/www || exit
    cp -R ./src/icons-splash/* ./dist/icons-splash || exit

    # Cleanup
    echo "Cleaning up www directory..."
    rm -f ./dist/www/config.js

    # Set some configs
    CONFIG_VERSION="$3"

    if [ "$2" = "dev" ]; then
        CONFIG_ENVIRONMENT="DEVELOPMENT"
    elif [ "$2" = "prod" ]; then
        CONFIG_ENVIRONMENT="PRODUCTION"
    elif [ "$2" = "stage" ]; then
        CONFIG_ENVIRONMENT="STAGING"
    fi

    if [ "$1" = "ios" ]; then
        CONFIG_PLATFORM="IOS"
    elif [ "$1" = "android" ]; then
        CONFIG_PLATFORM="ANDROID"
    fi

cat <<EOT >> ./dist/www/config.js
var ENVIRONMENT = '$CONFIG_ENVIRONMENT';
var PLATFORM = '$CONFIG_PLATFORM';
var VERSION = '$CONFIG_VERSION';
var IS_CORDOVA = true;
EOT

    # Auto-update the version in dist/config.xml
    sed "s/version=\"[^\"]*\"/version=\"$CONFIG_VERSION\"/g" "src/config.xml" > "dist/config.xml"

    # Build
    echo "Building Cordova app..."
    cd ./dist
    cordova platform add $1
    if [ "$2" = "prod" ]; then
        echo "Building for [RELEASE]"
        cordova build $1 --release
    else
        echo "Building for [DEBUG]"
        cordova build $1 --debug
    fi
    cd ../

    echo ""
    echo ""
    echo "Done!"
    echo ""
    echo ""
fi
