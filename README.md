# react-simple-deployment-ecs
This repository serves as a template for a client-side React.js application that leverages [Material UI](https://mui.com/) as the front-end framework.  It contains a GitHub Action that will deploy to Amazon Web Services (AWS) Elastic Container Service (ECS).  The intent is to create an automated pipeline so that you can leverage a low-cost approach to host a React.js application.

## Usage

Once you instantiate your own Github repository from this template, run `npm install` to install all of the required dependencies in your development environment.  To test it locally, run `npm start` to launch the local development server at `http://localhost:3000`.  There is a number of environment variables that you need to set in the `.github/workflows/deploy.yml` file (lines 13-21):

| Variable | Description |
|----------|-------------|
| IMAGE_TAG | Tag name to use to label the image to use in Elastic Container Registry |
| AWS_REGION | AWS region to deploy Elastic Container Service.  Allowable values for [AWS Region](https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html) |
| APP_NAME | Name of application |
| CLUSTER_NAME | Name of Elastic Container Service (ECS) cluster to create, if it does not exist |
| TASK_NAME | Name of ECS task definition to register to the ECS cluster |
| SERVICE_NAME | Name of ECS service to create, if it does not exist |
| EXECUTION_ROLE_NAME | Name of role to create (if necessary) to execute ECS task |
| CPU | Amount of vCPU to associate with ECS task definition |
| Memory | Amount of memory to associate with ECS task definition |

In addition to environment variables, it also expects these repository or organization secrets to exist:

| Secret | Description |
| ------ | ----------- |
| AWS_ACCESS_KEY_ID | Access key of an Identity Access Management (IAM) user |
| AWS_SECRET_ACCESS_KEY | Secret key of an IAM user |
| SECURITYGROUP_ID | ID of security group in which to associate for the ECS service |
| SUBNET_ID | ID of subnet in which to associate for the ECS service |
| AWS_ACCOUNT_ID | AWS account ID |

The IAM user must have this minimum permission:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ECRPermissions",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetDownloadUrlForLayer",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart",
                "ecr:CreateRepository",
                "ecr:DescribeRepositories"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ECSPermissions",
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DescribeClusters",
                "ecs:RegisterTaskDefinition",
                "ecs:DescribeTaskDefinition",
                "ecs:UpdateService",
                "ecs:CreateService",
                "ecs:DescribeServices"
            ],
            "Resource": "*"
        },
        {
            "Sid": "IAMRolePermissions",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:GetRole",
                "iam:AttachRolePolicy",
                "iam:PassRole"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VPCPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs",
                "ec2:DescribeNetworkInterfaces"
            ],
            "Resource": "*"
        },
        {
            "Sid": "LogsPermissions",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        }
    ]
}
```

## Future Consideration
- Include the ability to instantiate an Application Load Balancer (ALB) for production use
- Separate devolopment and production branch with either separate ECS cluster, or service / task definition

## See Also
- [react-deployment-s3](https://github.com/cloudful-io/react-deployment-s3): A ulta low-cost approach to host a client-side React.js application without a backend.

Happy Coding!