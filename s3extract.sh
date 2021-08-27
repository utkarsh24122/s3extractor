echo ""
echo "S3 bucket enumerator by @utkarsh24122"
target=$1
echo ""
echo "Target ===> $target"
echo "" 
echo "All Output stored in /"$target"_s3 "
echo "" 
mkdir $target_s3
cd $taget_s3

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Running Subdomain Enumeration & Extracting JS files \e[0m\n"

subfinder -d example.com -silent | httpx | subjs >> js1.txt
waybackurls example.com | grep ‘.js$’ >> js2.txt
gau -subs example.com | grep ‘.js$’ >> js3.txt


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Removing Duplicate Entries \e[0m\n"

cat js1.txt js2.txt js3.txt | sort -u >> JSfiles.txt
rm js1.txt js2.txt js3.txt

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m JS files' links saved in /"$target"_s3/JSfiles.txt \e[0m\n"


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Extracting S3 bucket names \e[0m\n"

cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “*.s3.amazonaws.com”’ >> s3_bucket.txt
cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “*.s3.us-east-2.amazonaws.com”’ >> s3_bucket.txt
cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “s3.amazonaws.com/*”’ >> s3_bucket.txt
cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “s3.us-east-2.amazonaws.com/*”’ >> s3_bucket.txt

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m S3 bucket names saved in /"$target"_s3/s3_bucket.txt \e[0m\n"
