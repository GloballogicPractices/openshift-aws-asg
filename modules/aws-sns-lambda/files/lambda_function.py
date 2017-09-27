from __future__ import print_function

import json
import boto3
import logging
import os


logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.info('Loading function')

def update_db():
    pass

def get_values():
    pass

def lambda_handler(event, context):
    """Read sns message, register instances in route53 """
    # Parse message from SNS
    ZONE=os.environ['ZONE']
    logger.info(event)
    logger.info(context)

    r53 = boto3.client('route53')
    print(r53)

    response_per_zone = r53.list_resource_record_sets(HostedZoneId=ZONE, MaxItems='100')

    print(response_per_zone)
