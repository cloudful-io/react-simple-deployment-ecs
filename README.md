# react-simple-deployment-ecs
This repository serves as a template for a client-side React.js application that leverages [Material UI][https://mui.com/] as the front-end framework.  It contains a GitHub Action that will deploy to Amazon Web Services (AWS) Elastic Container Service (ECS).  The intent is to create an automated pipeline so that you can leverage a low-cost approach to host a client-side React.js application.

## Usage

Once you instantiate your own Github repository from this template, run `npm install` to install all of the required dependencies in your development environment.  To test it locally, run `npm start` to launch the local development server at `http://localhost:3000`.  

 To use this template, it assumes that you have Terraform and the AWS CLI configured locally on your development environment and has the needed credentials:

1. to provision the needed AWS resources by Terraform
2) to deploy the React.js application build into the target S3 bucket

You MUST change the name of the S3 bucket that the build will be deployed to in Line 4 of the `terraform/main.tf` file.  Since S3 server access logging is enabled for best security practice, you MUST also change the name of the S3 logging bucket in Line 9 of the `terraform/main.tf` file.  After that, you will be able to run the `npm run deploy` command.  One of the outputs of the Terraform module is the URL of the AWS CloudFront distribution, with which you can use to validate that the AWS infrastructure has been deployed correctly.

Happy Coding!