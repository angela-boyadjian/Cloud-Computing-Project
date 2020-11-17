'use strict';

const AWS = require('aws-sdk');
AWS.config.update({region: process.env.AWS_REGION}); 
var ECS = new AWS.ECS();

const ECS_TASK_DEFINITION = "ReceiptsReportingFamily";
const pdf_file = "test.pdf";
const OUTPUT_S3_PATH = "test.pdf";
const OUTPUT_S3_AWS_REGION = "eu-west-2";

module.exports.crawldb = async (event, context, callback) => {
  const params = {
    cluster: "cluster-receipts",
    launchType: 'FARGATE',
    networkConfiguration: {
      awsvpcConfiguration: {
        subnets: [
          'subnet-09a8a260e5bf1296a'
        ],
        assignPublicIp: 'DISABLED',
      }
    },
    taskDefinition: `${ECS_TASK_DEFINITION}`,
    count: 1,
    platformVersion:'LATEST',
    overrides: {
      containerOverrides: [
        {
          name: 'reicepts-crawler',
          environment: [
            {
              name: 'OUTPUT_PDF_FILE_NAME',
              value: `${pdf_file}`
            },
            {
              name: 'OUTPUT_S3_PATH',
              value: `${OUTPUT_S3_PATH}`
            },
            {
              name: 'AWS_REGION',
              value: `${OUTPUT_S3_AWS_REGION}`
            }
          ]
        }
      ]
    }
  };
  await ECS.runTask(params).promise();
  console.log('Running Fargate task')
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Task launched',
        input: event,
      },
      null,
      2
    ),
  };
}
