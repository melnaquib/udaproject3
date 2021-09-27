
#echo "Create Database"
#echo "Create RDS with "
#echo "Create S3"
#echo "Create cloudfront"


export OLDWORKFLOWID=$(aws cloudformation list-exports \
              --query "Exports[?Name==\`WorkflowID\`].Value" \
              --no-paginate \
              --output text --profile abdulsal)
export STACKS=($(aws cloudformation list-stacks --query "StackSummaries[*].StackName" \
              --stack-status-filter CREATE_COMPLETE --no-paginate --output text --profile abdulsal))
echo "STACK WITH FILTER ${STACKS:19}"
#export STACKS=($(aws cloudformation list-stacks --query "StackSummaries[*].StackName" \
#               --no-paginate --output text --profile abdulsal))              
echo Old Workflow Id :  "${OLDWORKFLOWID}"
#export OLDWORKFLOWID="77a73d99-2e65-42ee-8550-76a7b98ee177"
#echo "$OLDWORKFLOWID"
echo "STACKS : $STACKS"
if [[ "${STACKS:19}" != "${OLDWORKFLOWID}" ]]
then
    echo "Not equal delete old s3"
fi
exit
export CIRCLE_WORKFLOW_ID="77a73d99-2e65-42ee-8550-76a7b98ee177"
aws cloudformation deploy \
              --template-file .circleci/files/cloudfront.yml \
              --stack-name udapeople-cloudfront \
              --parameter-overrides WorkflowID="${CIRCLE_WORKFLOW_ID}" \
              --tags project=udapeople --profile abdulsal
exit
export OLDWORKFLOWID="77a73d99-2e65-42ee-8550-76a7b98ee177"
aws s3 rm "s3://udapeople-${OLDWORKFLOWID}" --recursive --profile abdulsal
aws cloudformation delete-stack --stack-name "udapeople-frontend-${OLDWORKFLOWID}" --profile abdulsal
aws cloudformation delete-stack --stack-name "udapeople-backend-${OLDWORKFLOWID}"  --profile abdulsal