'use strict';
const AWS = require('aws-sdk');
const uuid = require('uuid');
AWS.config.update({region: process.env.AWS_REGION}); 
const db = new AWS.DynamoDB.DocumentClient();
const TableName = process.env.FINANCES_TABLE;

module.exports = {
  setUpDatabase: async(event, context, callback) => {
    const userId = event.request.userAttributes.sub;

    const Item = {
      userId: userId,
      receipts: [],
      budgets:[
        {
          id: uuid.v4(),
          category: 'family',
          amount: 0.0
        },
        {
          id: uuid.v4(),
          category: 'vacation',
          amount: 0.0
        },
        {
          id: uuid.v4(),
          category: 'saving',
          amount: 0.0
        }
      ]
    };

    try {
      await db.put({
        TableName,
        Item
      }).promise();
    } catch (error) {
      console.log("oh. An error occured.", error);
    }
    callback(null, event);
  }
}