# s3extractor ☁
Bash Script to extract s3 buckets from JS files of the target.

- ⚙ How it works: 
1. Finds Subdomains of the target
2. Extracts JavaScript files from the target and its subdomains
3. Finds S3 buckets in those JS files
4. Checks Permissions of the buckets (CRUD operations) using aws cli

# 📝
- S3 buckets can also be found in Android Applications. My tools [APKnuke] and [APKanalyser] can extract S3 buckets from an APK
- A misconfigured S3 bucket may lead to a Subdomain takeover
