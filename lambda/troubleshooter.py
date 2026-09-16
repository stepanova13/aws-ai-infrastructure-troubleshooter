import json
import os
import boto3
from datetime import datetime, timezone

cloudwatch = boto3.client("cloudwatch")
ec2 = boto3.client("ec2")
bedrock = boto3.client("bedrock-runtime")
s3 = boto3.client("s3")

MODEL_ID = os.environ["BEDROCK_MODEL_ID"]
REPORT_BUCKET = os.environ["REPORT_BUCKET"]


def get_ec2_information():
    response = ec2.describe_instances()

    instances = []

    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instances.append({
                "InstanceId": instance.get("InstanceId"),
                "State": instance.get("State", {}).get("Name"),
                "InstanceType": instance.get("InstanceType"),
                "PrivateIpAddress": instance.get("PrivateIpAddress"),
                "PublicIpAddress": instance.get("PublicIpAddress"),
            })

    return instances


def get_cloudwatch_metrics(instance_id):
    metrics = cloudwatch.list_metrics(
        Namespace="AWS/EC2",
        Dimensions=[
            {
                "Name": "InstanceId",
                "Value": instance_id
            }
        ]
    )

    metric_names = []

    for metric in metrics.get("Metrics", []):
        metric_names.append(metric.get("MetricName"))

    return metric_names


def analyze_with_ai(infrastructure_data, user_problem):
    prompt = f"""
You are an AWS Cloud Infrastructure Troubleshooter.

Analyze the AWS infrastructure information below and help identify
possible causes of the reported problem.

Reported problem:
{user_problem}

Infrastructure information:
{json.dumps(infrastructure_data, indent=2)}

Provide your response using this structure:

1. Problem Summary
2. Most Likely Root Cause
3. Evidence
4. Recommended AWS Checks
5. Recommended Fix
6. Prevention

Do not invent AWS resources or metrics that are not provided.
Clearly state when additional information is required.
"""

    request_body = {
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "text": prompt
                    }
                ]
            }
        ],
        "inferenceConfig": {
            "max_new_tokens": 800,
            "temperature": 0.2
        }
    }

    response = bedrock.invoke_model(
        modelId=MODEL_ID,
        body=json.dumps(request_body),
        contentType="application/json",
        accept="application/json"
    )

    response_body = json.loads(response["body"].read())

    return response_body["output"]["message"]["content"][0]["text"]


def save_report(report):
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")

    key = f"reports/troubleshooting-{timestamp}.json"

    s3.put_object(
        Bucket=REPORT_BUCKET,
        Key=key,
        Body=json.dumps(report, indent=2),
        ContentType="application/json"
    )

    return key


def lambda_handler(event, context):

    try:
        body = event.get("body", "{}")

        if isinstance(body, str):
            body = json.loads(body)

        user_problem = body.get(
            "problem",
            "The AWS infrastructure is experiencing an unknown problem."
        )

        instances = get_ec2_information()

        infrastructure_data = {
            "ec2_instances": instances
        }

        for instance in instances:

            instance_id = instance.get("InstanceId")

            if instance_id:
                infrastructure_data[
                    f"metrics_{instance_id}"
                ] = get_cloudwatch_metrics(instance_id)

        ai_analysis = analyze_with_ai(
            infrastructure_data,
            user_problem
        )

        report = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "problem": user_problem,
            "infrastructure": infrastructure_data,
            "ai_analysis": ai_analysis
        }

        report_key = save_report(report)

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "message": "Infrastructure analysis completed.",
                "report_location": report_key,
                "analysis": ai_analysis
            })
        }

    except Exception as error:

        print(f"ERROR: {str(error)}")

        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "error": "Infrastructure troubleshooting failed.",
                "details": str(error)
            })
        }