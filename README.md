# AWS AI Infrastructure Troubleshooter

An AWS serverless DevOps project that uses **Amazon Bedrock and AWS infrastructure data to analyze potential infrastructure problems and provide troubleshooting recommendations.**

## 🚀 Project Overview

The AWS AI Infrastructure Troubleshooter is a serverless application designed to help identify potential AWS infrastructure issues.

A user submits a problem through an API. AWS Lambda collects infrastructure information and CloudWatch metrics, sends the available data to **Amazon Bedrock**, and receives an AI-generated troubleshooting analysis.

The analysis is then stored as a JSON report in Amazon S3.

## 🏗️ Architecture

```text
                    User
                      │
                      ▼
              Amazon API Gateway
                      │
                      ▼
              AWS Lambda (Python)
                 /           \
                /             \
               ▼               ▼
        AWS Infrastructure   CloudWatch
           Information         Metrics
                \               /
                 \             /
                  ▼           ▼
                  Amazon Bedrock
                  Nova Micro
                      │
                      ▼
              AI Troubleshooting
                   Analysis
                      │
                      ▼
                  Amazon S3
                JSON Report
```

## ☁️ AWS Services Used

* **Amazon API Gateway** – receives troubleshooting requests
* **AWS Lambda** – serverless troubleshooting logic written in Python
* **Amazon Bedrock** – AI-powered infrastructure analysis
* **Amazon EC2** – infrastructure information source
* **Amazon CloudWatch** – monitoring and metrics
* **Amazon S3** – stores troubleshooting reports
* **AWS IAM** – controls permissions
* **AWS CloudWatch Logs** – Lambda logging and monitoring
* **Terraform** – Infrastructure as Code

## 🛠️ Technologies

* AWS
* Terraform
* Python
* Boto3
* Amazon Bedrock
* REST API
* Git / GitHub
* CloudWatch
* Infrastructure as Code (IaC)
* Serverless Architecture

## 🔍 How It Works

1. A user submits an infrastructure problem through the API.
2. API Gateway sends the request to Lambda.
3. Lambda collects information about AWS infrastructure.
4. Lambda retrieves available CloudWatch monitoring information.
5. The infrastructure data and reported problem are sent to Amazon Bedrock.
6. Amazon Bedrock analyzes the information.
7. The AI generates:

   * Problem Summary
   * Most Likely Root Cause
   * Evidence
   * Recommended AWS Checks
   * Recommended Fix
   * Prevention Recommendations
8. Lambda stores the complete troubleshooting report in Amazon S3.
9. The API returns the AI analysis to the user.

## 🧪 Example Request

```bash
curl -X POST \
  "YOUR_API_ENDPOINT/troubleshoot" \
  -H "Content-Type: application/json" \
  -d '{"problem":"My EC2 instance is running slowly. Help me identify possible causes."}'
```

## 📄 Example Response

```json
{
  "message": "Infrastructure analysis completed.",
  "report_location": "reports/troubleshooting-YYYYMMDD-HHMMSS.json",
  "analysis": "1. Problem Summary..."
}
```

## 🏗️ Infrastructure as Code

All AWS infrastructure is deployed using Terraform.

The Terraform configuration creates and manages:

* IAM roles and policies
* Lambda function
* API Gateway REST API
* S3 bucket
* S3 versioning
* S3 server-side encryption
* S3 public access blocking
* CloudWatch Log Group
* CloudWatch metric filter
* CloudWatch alarm

This allows the entire environment to be reproduced using:

```bash
terraform init
terraform plan
terraform apply
```

The infrastructure can also be removed with:

```bash
terraform destroy
```

## 🔐 Security Considerations

The project follows several AWS security best practices:

* IAM permissions are explicitly defined for the Lambda function.
* S3 public access is blocked.
* S3 server-side encryption is enabled.
* S3 versioning is enabled.
* Lambda logs are retained in CloudWatch.
* AWS credentials are not stored in the repository.
* Terraform state files and `.tfvars` files are excluded through `.gitignore`.

> Note: The API Gateway endpoint is currently configured without authentication for development and testing. Production deployments should use appropriate authentication, authorization, throttling, and monitoring.

## 💰 Cost Considerations

The project is designed to minimize AWS costs by using serverless services and **Amazon Nova Micro**, a low-cost Bedrock model.

Resources should be destroyed when they are no longer needed:

```bash
terraform destroy
```

## 📁 Project Structure

```text
aws-ai-infrastructure-troubleshooter/
│
├── .gitignore
├── README.md
│
├── terraform/
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── iam.tf
│   ├── s3.tf
│   ├── lambda.tf
│   ├── api_gateway.tf
│   ├── cloudwatch.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── terraform.tfvars
│
└── lambda/
    └── troubleshooter.py
```

## 🎯 Project Goals

This project demonstrates practical experience with:

* AWS cloud architecture
* Infrastructure as Code
* Terraform
* Serverless computing
* Python and Boto3
* AWS monitoring
* IAM
* API development
* AI integration with Amazon Bedrock
* Automated infrastructure troubleshooting
* Cloud security practices
* Git and GitHub

## 🔮 Future Improvements

Planned improvements include:

* Retrieve actual CloudWatch metric values instead of only metric names
* Add EC2 CPU utilization analysis
* Analyze EC2 status check failures
* Analyze EBS performance
* Add automated remediation recommendations
* Add API authentication
* Add API throttling
* Add CloudWatch dashboards
* Add automated tests
* Add CI/CD with GitHub Actions
* Add additional AWS resource checks
* Improve AI prompts and structured output
* Add automated infrastructure remediation with user approval

## 👩‍💻 Author

**Alexandra Stepanova**

AWS Cloud / DevOps Engineer

This project was created to demonstrate practical AWS, DevOps, Infrastructure as Code, Python, monitoring, and AI engineering skills.
