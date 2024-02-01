#!/bin/bash

read -p "Target: " target

rm -rf "$target"

while [ "$target" == "" ]; 
do
        read -p "Target: " target
done

#criar diretorios
mkdir -p "$target"
mkdir js
mkdir json
mkdir txt
mkdir xml
mkdir pdf
mkdir first_recon
mv js json txt xml pdf first_recon "$target"
echo "directory $target created."

#---
#chaos section

chaos -d "$target" | anew "$target/chaos1" | lolcat
echo -e "\nChaos completed."

chaos -d "$target/chaos1" | anew "$target/subdomains" | lolcat
echo -e "\nChaos phase 2 completed."

mv "$target/chaos1" "$target/first_recon"

#-----
#subfinder section

subfinder -d "$target" -silent | anew "$target/subfinder1" | lolcat
echo -e "\nsubfinder task completed"

subfinder -d "$target/subfinder1" | anew "$target/subdomains" | lolcat
echo -e "\nsubfinder recon do recon completed"

mv "$target/subfinder1" "$target/first_recon"

#---
#amass section

amass enum -d "$target" -silent | anew "$target/amass1" | lolcat
echo -e "\namass task completed."

amass enum -d "$target/amass1" -silent | anew "$target/subdomains"
echo -e "\nAmass recon do recon completed."

mv "$target/amass1" "$target/first_recon"

#---
#findomain seciton

findomain -t "$target" | anew "$target/findomain1" | lolcat
echo -e "\nFindomain task completed."

findomain -t "$target/findomain1" | anew "$target/subdomains" | lolcat
echo -e "\nFindomain recon do recon completed."

mv "$target/findomain1" "$target/first_recon"

#---
#haktrails

echo "$target" | haktrails subdomains | anew "$target/subdomains" | lolcat
echo -e "\nHaktrails task completed."

#---
#assetFinder
assetfinder -subs-only "$target" | anew "$target/asset1" | lolcat
echo -e "\nAsset task completed"

assetfinder -subs-only "$target/asset1" | anew "$target/subdomains" | lolcat
echo -e "\nAssetFinder task completed"

mv "$target/asset1" "$target/first_recon"
#---
#github search
source /home/bugbounty/github-search/bin/activate
python3 /../../home/bugbounty/github-search/github-subdomains.py -d "$target" | anew "$target/subdomains" | lolcat
deactivate
echo -e "\nGithubSearch task completed"

#---
Echo "All results at "$target/subdomains"
