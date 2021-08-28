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


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Running Subdomain Enumeration & Extracting JS files ... \e[0m\n"

subfinder -d $target -silent | httpx | subjs >> js1.txt
waybackurls $target | grep ‘.js$’ >> js2.txt
gau -subs $target | grep ‘.js$’ >> js3.txt


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Removing Duplicate Entries ... \e[0m\n"

cat js1.txt js2.txt js3.txt | sort -u >> JSfiles.txt
rm js1.txt js2.txt js3.txt

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m JS files' links saved in /"$target"_s3/JSfiles.txt \e[0m\n"


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Extracting S3 bucket links \e[0m\n"

cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “*.s3.amazonaws.com”’ >> bucket_links.txt
cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “*.s3.us-east-2.amazonaws.com”’ >> bucket_links.txt
cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “s3.amazonaws.com/*”’ >> bucket_links.txt
cat JSfiles.txt | xargs -I% bash -c ‘curl -sk “%” | grep -w “s3.us-east-2.amazonaws.com/*”’ >> bucket_links.txt

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m S3 bucket links saved in /"$target"_s3/bucket_links.txt \e[0m\n"


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Extracting S3 bucket names \e[0m\n"

cat bucket_links.txt | sed ‘s/s3.amazonaws.com//’ >> bucket_names.txt
cat bucket_links.txt | sed ‘s/s3.us-east-2.amazonaws.com//’ >> bucket_names.txt

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m S3 bucket links saved in /"$target"_s3/bucket_names.txt \e[0m\n"


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Checking Bucket Permissions \e[0m\n"

cat bucket_names.txt | xargs -I% sh -c ‘aws s3 cp test.txt s3://% 2>&1 | grep “upload” && echo “ AWS s3 bucket unauthenticated Upload permission %”’
cat bucket_names.txt | xargs -I% sh -c ‘aws s3 rm test.txt s3://%/test.txt 2>&1 | grep “delete” && echo “ AWS s3 bucket unauthenticated Delete permission %”’

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Scan complete!!! Exiting... \e[0m\n"



