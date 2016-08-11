
echo $PROJECT
#Check if github repo has GUID
RESPONSE=`curl -I $GIT_URL/blob/master/GUID 2>/dev/null | head -n 1 | cut -d$' ' -f2`
#If not
if [[ $RESPONSE != "200" ]];
#Hash Code
then CODE_HASH=`md5 -q fast.c`;
#Hit forgeorck endpoint with  hash and get code GUID
GUID_CODE=`curl -H "Content-Type: application/json" -X POST -d '{"hash":"'"$CODE_HASH"'"}' http://localhost:5000/code`
#Convert GUID to base 64
GUID_CODE_b=`echo $GUID_CODE | base64`;
#GET github project name
PROJECT=`echo "$GIT_URL.git" | sed 's%^.*/\([^/]*\)\.git$%\1%g'`
#Remove project name from git url
NO_PROJECT=${GIT_URL%/*}
#Get username from above variable
USERNAME=${NO_PROJECT##*/}
#Push GUID github repo
curl -i -X PUT -u $1:x-oauth-basic -d '{"path": "GUID", "message": "GUID ADD", "content": "'"$GUID_CODE_b"'", "branch": "master" }' https://api.github.com/repos/$USERNAME/$PROJECT/contents/GUID;
fi
#Compile Code
gcc fast.c -o fast
#Hash binary
BINARY_HASH=`md5 -q fast`
#Hit forgerock endpoint with  hash and get binary GUID
GUID_BINARY=`curl -H "Content-Type: application/json" -X POST -d '{"hash":"'"$BINARY_HASH"'"}' http://localhost:5000/binary`
#Output binary GUID to file
echo $GUID_BINARY > GUID

