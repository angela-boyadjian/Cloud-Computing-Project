'use strict'

const AWS = require('aws-sdk');
const uuid = require('uuid');
const qs = require('querystring')
AWS.config.update({region: process.env.AWS_REGION}); 
const db = new AWS.DynamoDB.DocumentClient();
const TableName = process.env.RECEIPTS_TABLE;

module.exports = {
    get: async(event, context) => {
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: "This is a test",
            })
        }
    },
    post: async(event, context) => {
        const data = qs.parse(event.body);
        const userId = event.requestContext.authorizer.claims.sub;

        if (data.store === undefined || data.price === undefined || data.category === undefined) {
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: "Missing parameters."
                })
            }
        }
        const Item = {
            receiptId: uuid.v4(),
            userId: userId,
            store: data.store,
            price: parseFloat(data.price),
            category: data.category,
            date: new Date().getTime()
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