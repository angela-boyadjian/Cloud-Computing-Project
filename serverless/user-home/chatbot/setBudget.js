'use strict';

module.exports.lex_setBudget = async event => {
    console.log(event);
    let lambda_response = {
        "sessionAttributes": {
            "amount": event.currentIntent.slots.AMOUNT,
            "current_budget": event.currentIntent.slots.BUDGET_CATEGORY
        },
        "dialogAction": {
            "type": "Close",
            "fulfillmentState": "Fulfilled",
            "message": {
                "contentType": "PlainText",
                "content": "Your budget of " + event.currentIntent.slots.AMOUNT + "$ has been confirmed for category " + event.currentIntent.slots.BUDGET_CATEGORY
            },
        }
    }
    return lambda_response;
  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
