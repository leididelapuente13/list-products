import { APIGatewayProxyHandler } from 'aws-lambda';
import { DynamoDBClient, ScanCommand } from '@aws-sdk/client-dynamodb';
import { unmarshall } from '@aws-sdk/util-dynamodb';

const dynamoDBClient = new DynamoDBClient({ region: 'us-west-1' });

export const listProducts: APIGatewayProxyHandler = async () => {
  try {
    const params = {
      TableName: 'Products',
    };
    const { Items } = await dynamoDBClient.send(new ScanCommand(params));
    const products = Items ? Items.map(item => unmarshall(item)) : [];

    return {
      statusCode: 200,
      body: JSON.stringify({ data: products }),
    };
  } catch (error) {
    console.error('Error fetching products:', error);
    return { statusCode: 500, body: JSON.stringify({ error: 'Internal Server Error' }) };
  }
};
