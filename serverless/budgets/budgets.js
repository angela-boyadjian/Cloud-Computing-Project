'use strict'

const AWS = require('aws-sdk');
const uuid = require('uuid');
const qs = require('querystring')
AWS.config.update({region: process.env.AWS_REGION}); 
const db = new AWS.DynamoDB.DocumentClient();
const TableName = process.env.BUDGETS_TABLE;

module.exports = {
    get: async(event, context) => {
        const userId = event.requestContext.authorizer.claims.sub;
        const params = {
            KeyConditionExpression: "#uid = :uid",
            ExpressionAttributeNames:{
                "#uid": "userId"
            },
            ExpressionAttributeValues: {
                ":uid": userId
            },
            TableName
        }
        let result = {};

        try {
            result = await db.query(params).promise();
        } catch (error) {
            console.log("An error occurred.", error);
            return {
                statusCode: 500
            }
        }
        return {
            statusCode: 200,
            body: JSON.stringify({
                result
            })
        }
    },
    post: async(event, context) => {
        const data = qs.parse(event.body);
        const userId = event.requestContext.authorizer.claims.sub;
        
        if (data.amount === undefined || data.category === undefined) {
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: "Missing parameters."
                })
            }
        }
        const Item = {
            budgetsId: uuid.v4(),
            userId: userId,
            amount: data.amount,
            category: data.category,
        }
        let result = {};

        try {
            result = await db.put({
                TableName,
                Item
            }).promise();
        } catch (error) {
            console.log("oh. An error occured.", error);
            return {
                statusCode: 500
            }
        }
        return {
            statusCode: 200
        }
    }
}