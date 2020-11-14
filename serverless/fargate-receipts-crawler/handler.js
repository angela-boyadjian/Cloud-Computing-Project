'use strict';

const ECS_TASK_DEFINITION = "spendingCrawler";
const pdf_file = "test.pdf";
const OUTPUT_S3_PATH = "test.pdf";
const OUTPUT_S3_AWS_REGION = "eu-west-2";

const ecsApi = require('./ecs');


module.exports.crawldb = (event, context, callback) => {
  const params = {
    cluster: "clusterSpending",
    launchType: 'FARGATE',
    taskDefinition: `${ECS_TASK_DEFINITION}`,
    count: 1,
    platformVersion:'LATEST',
    overrides: {
      containerOverrides: [
        {
          name: 'spendingCrawler',
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

  ecsApi.runECSTask(params).then(param, data=> {
    console.log(param, data);
    return {
      statusCode: 200,
      body: JSON.stringify(
        {
          message: `ECS Task ${params.taskDefinition} started: ${JSON.stringify(data.tasks)}`,
        },
        null,
        2
      ),
    };
    return data;
  }).catch((err) => {
    console.error(err);
    return err;
  });

 

}
