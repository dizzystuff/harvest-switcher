#!/bin/bash

function exitIfRunning {
  if ps ax | grep -v grep | grep Harvest > /dev/null
  then
    echo "You must quit Harvest before continuing."
    exit 1
  fi
}

function removeCurrentPreferences {
  if [ -e com.getharvest.harvestxapp.plist ]
  then
    rm com.getharvest.harvestxapp.plist
  fi
}

function switchAccount {
  if [ -e com.getharvest.harvestxapp.plist_$1 ]
  then
    removeCurrentPreferences
    ln -s "com.getharvest.harvestxapp.plist_$1" com.getharvest.harvestxapp.plist
  else
    echo "There are no preferences saved as $1."
    exit 1
  fi
}

function createAccount {
  if [ -h com.getharvest.harvestxapp.plist ]
  then
    removeCurrentPreferences
    open /Applications/Harvest.app
    echo "1) Configure your new account."
    echo "2) Quit Harvest."
    read -p "3) Press [Enter]."
  fi

  mv com.getharvest.harvestxapp.plist "com.getharvest.harvestxapp.plist_$1"
  ln -s "com.getharvest.harvestxapp.plist_$1" com.getharvest.harvestxapp.plist
}

exitIfRunning
cd ~/Library/Preferences
case $1 in
"")
  open /Applications/Harvest.app
  ;;
new)
  if [ ! -n "$2" ]
  then
    echo "Enter an account name: harvest new account_name"
  else
    createAccount $2
  fi
  ;;
*)
  switchAccount $1
  open /Applications/Harvest.app
  ;;
esac
