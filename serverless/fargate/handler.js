'use strict';

const AWS = require('aws-sdk');
AWS.config.update({region: process.env.AWS_REGION});
const ECS = new AWS.ECS();

module.exports.launch = async(event, context) => {
    const ECSCluster = process.env.ECS_CLUSTER;
    const ECSSecGroup = process.env.ECS_SEC_GROUP;
    const ECSSubnet = process.env.ECS_SUBNET;
    const ECSTaskArn = process.env.ECS_TASK_ARN;
    const CONTAINER_NAME = process.env.CONTAINER_NAME;

    let data;
    try {
        data = await ECS.runTask({
            cluster:ECSCluster,
            taskDefinition:ECSTaskArn,
            count:1,
            launchType:"FARGATE",
            overrides:{
                containerOverrides: [{
                    "name": CONTAINER_NAME,
                    "command": [
                        "npm",
                        "start",
                    ],
                    "environment": [
                        {
                            "name": "FEED_BUCKET_NAME",
                            "value": process.env.FEED_BUCKET_NAME
                        },
                        {
                            "name": "HTTP_CACHE_BUCKET_NAME",
                            "value": process.env.HTTP_CACHE_BUCKET_NAME
                        },
                    ]
                }]
            },
            networkConfiguration: {
                "awsvpcConfiguration": {
                    "subnets": [
                        ECSSubnet
                    ],
                    "securityGroups": [
                        ECSSecGroup
                    ],
                    "assignPublicIp": "ENABLED"
                }
            }
        }).promise();
        console.log(data);
    } catch(err) {
        console.log("An error occured: "+err);
    }
}