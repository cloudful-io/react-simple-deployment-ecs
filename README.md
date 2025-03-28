# react-deployment-s3
This repository serves as a template for a client-side React.js application that leverages [Material UI][https://mui.com/] as the front-end framework.  It contains a GitHub Action that will deploy to an Amazon Web Services (AWS) Simple Storage Service (S3) bucket of your choice.  The intent is to create an automated pipeline so that you can leverage a super low-cost approach to host a client-side React.js application.    Because of the limitation of S3 static web hosting of not supporting HTTPS, this project also instantiates a AWS CloudFront distribution to sit in front of the S3 bucket. 

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.3.0 |
| AWS Command Line Interface | 2.0.0 |

## Usage

To use this template, it assumes that you have Terraform and the AWS CLI configured locally on your development environment and has the needed credentials: 1) to provision the needed AWS resources by Terraform; 2) to deploy the React.js application build into the target S3 bucket.  You MUST change the name of the S3 bucket that the build will be deployed to in Line 4 of the `terraform/main.tf` file.  Since S3 server access logging is enabled for best security practice, you MUST also change the name of the S3 logging bucket in Line 9 of the `terraform/main.tf` file.  After that, you will be able to run the `npm run deploy` command.  One of the outputs of the Terraform module is the URL of the AWS CloudFront distribution.

Happy Coding!