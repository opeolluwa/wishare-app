#!/bin/bash

alias w:= watch
alias b:= build
alias l:= lint
alias install := install-dependencies

APP_NAME := "filesync"
MINIMUM_STABLE_RUST_VERSION :="1.83.0"
EXPORT_PATH := "bin"

default: 
    @just --list --list-heading $'Available commands\n'

[doc('Install the application dependencies')]
install-dependencies: 
    echo "Installing dependencies"
    cargo install trunk --locked
    rustup target add wasm32-unknown-unknown


[doc('Lint')]
lint:
    cargo fmt && cargo clippy

[doc('Run the application in watch mode')]
watch target:
    #!/usr/bin/env sh
    export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
    
    if [ {{target}} = "android" ]; then
        cargo tauri android dev 
    elif [ {{target}} = "ios" ]; then 
        cargo tauri ios dev 
    elif [ {{target}} = "styles" ]; then
        npx tailwindcss -i ./main.css -o ./style/output.css --watch --minify
    else
        cargo tauri dev
    fi

[doc('build the application ')]
[group('watch')]
build target:
    #!/usr/bin/env sh
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
    if [ {{target}} = "android" ]; then
        cargo tauri android build --apk
    elif [ {{target}} = "ios" ]; then 
        cargo tauri ios build --aab
    else
        cargo tauri build 
    fi


export: 
    #!/usr/bin/env sh
    # mkdir bin 
    cp src-tauri/gen/android/app/build/outputs/apk/universal/release/app-universal-release.apk $EXPORT_PATH/$APP_NAME.apk
    cp src-tauri/gen/android/app/build/outputs/bundle/universalRelease/app-universal-release.aab $EXPORT_PATH/$APP_NAME.aab
    cp src-tauri/target/release/bundle/dmg/filesync_0.7.13_aarch64.dmg $EXPORT_PATH/$APP_NAME.dmg