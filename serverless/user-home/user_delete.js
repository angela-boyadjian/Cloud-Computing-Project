'use strict';

module.exports.delete = async event => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Home route',
        input: event,
      },
      null,
      2
    ),
  };
};
