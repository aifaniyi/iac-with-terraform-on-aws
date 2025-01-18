const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();
const tableName = process.env.COMMENTS_DYNAMO_TABLE

exports.handler = async (event, context) => {
    for (const message of event.Records) {
        await processMessageAsync(message);
    }

    console.info("done");
};

const processMessageAsync = async (message) => {
    try {
        console.info(`inserting message into ${tableName}`)
        console.info(message)

        const result = await dynamo.put({
            TableName: tableName,
            Item: JSON.parse(message.body)
        }).promise()

        console.info(result)
        console.info(`inserted message`)
    } catch (err) {
        console.error("An error occurred");
        throw err;
    }
}