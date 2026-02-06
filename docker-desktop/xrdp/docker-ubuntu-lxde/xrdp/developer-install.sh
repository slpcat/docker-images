#!/bin/bash
set -x -e

# jenkins agent
# /usr/share/jenkins/agent.jar
# $HOME/.icewm/startup
# java -jar /usr/share/jenkins/agent.jar \
#  -jnlpUrl http://your-jenkins-server:8080/computer/your-node-name/slave-agent.jnlp \
#  -secret your-secret-key \
#  -workDir ~/jenkins-agent

#pyenv
#git clone https://gitcode.com/GitHub_Trending/py/pyenv.git ~/.pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init - bash)"

#Conda
#https://www.anaconda.com/download/success
#wget https://repo.anaconda.com/archive/Anaconda3-2025.12-1-Linux-x86_64.sh
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Jupyter Notebook

# sdkman
# https://sdkman.io/
curl -s "https://get.sdkman.io" | bash

# gvm
#https://github.com/moovweb/gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
# 激活 gvm，使用上述命令屏幕展示的命令
#source ~/.gvm/scripts/gvm

# nvm
#https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Bun is an all-in-one toolkit for JavaScript and TypeScript apps.
curl -fsSL https://bun.sh/install | bash
# or you can use npm
# npm install -g bun

# rustup
# https://rustup.rs/
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# zigup
# https://github.com/marler8997/zigup
curl -L https://github.com/marler8997/zigup/releases/latest/download/zigup-x86_64-linux.tar.gz | tar xz

#IntelliJ IDEA

# redroid (Remote anDroid) is a GPU accelerated AIC (Android In Cloud) solution.
#https://github.com/remote-android/redroid-doc

# android sdkmanager
#https://dl.google.com/android/repository/platform-tools-latest-linux.zip

# Android Emulator
# https://developer.android.com/studio/emulator_archive

# android studio
# flatpak install -y flathub com.google.AndroidStudio
# https://developer.android.com/studio/archive
# https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.2.3.9/android-studio-2025.2.3.9-linux.tar.gz

# dart sdk
#sudo apt update && sudo apt install -y apt-transport-https wget gnupg
#wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
# | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
#echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] \
#https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' \
# | sudo tee /etc/apt/sources.list.d/dart_stable.list

#sudo apt update && sudo apt install -y dart
#echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.bashrc
#source ~/.bashrc

# fvm Easy, powerful and flexible tool to manage multiple Flutter SDK versions.
# curl -fsSL https://fvm.app/install.sh | bash

# HarmonyOS SDK
# DevEco Studio
#https://developer.huawei.com/consumer/cn/deveco-studio/

# Arduino IDE
#wget https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.7_Linux_64bit.zip

# sonar-scanner-cli

#Robot Framework is a generic open source automation framework.
#    pip3 install robotframework

# selenium
npm install -g selenium-side-runner

python3 -m venv selenium
source selenium/bin/activate
pip3 install selenium

# playwright
python3 -m venv playwright
source playwright/bin/activate
pip3 install playwright
playwright install

# appium
#npm install appium-doctor --location=global
#npm install appium --location=global
#npm install appium-android-driver --location=global

# vscode extensions
# Install default supported themes
code --install-extension enkia.tokyo-night
# https://www.continue.dev/
code --install-extension continue.continue

# Install AI coding/Vibe coding tools

# Claude Code , Cursor CLI, CodeX,Gemini CLI,cline
curl https://cursor.com/install -fsS | bash

npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex
npm install -g @google/gemini-cli
npm install -g cline

# flatpak

# appimage

# https://github.com/sickcodes/Docker-OSX
# https://github.com/sickcodes/Docker-eyeOS

#######################################################

#Label Studio is an open source data labeling tool. 
#https://github.com/HumanSignal/label-studio
