import { APIGatewayProxyHandler } from 'aws-lambda';
import { ScanCommand } from '@aws-sdk/client-dynamodb';
import { unmarshall } from '@aws-sdk/util-dynamodb';
import { dynamoDBClient } from './database/dynamoClient';

export const handler: APIGatewayProxyHandler = async () => {
  try {
    const params = {
      TableName: process.env.PRODUCTS_TABLE_NAME || 'Products',
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
