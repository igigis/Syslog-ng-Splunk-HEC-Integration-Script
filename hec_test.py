#!/usr/bin/env python3

import requests
import logging
import datetime
import json

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def test_hec_connectivity():
    # HEC configuration
    splunk_host = "https://hec.huntress.io"
    hec_token = "<hec token>"

    # Test event
    test_event = {
        "time": int(datetime.datetime.now().timestamp()),
        "host": "test-host",
        "source": "test-source",
        "sourcetype": "test-sourcetype",
        "event": "test event data"
    }

    # HEC request headers
    headers = {
        "Authorization": f"Splunk {hec_token}",
        "Content-Type": "application/json"
    }

    try:
        # Log request details
        logging.info(f"Testing HEC endpoint: {splunk_host}/services/collector")
        logging.info(f"Request headers: {json.dumps(headers, indent=2)}")
        logging.info(f"Test event: {json.dumps(test_event, indent=2)}")

        # Send test event
        response = requests.post(
            f"{splunk_host}/services/collector",
            headers=headers,
            json=test_event,
            verify=True
        )

        # Log response details
        logging.info(f"Response Status Code: {response.status_code}")
        logging.info(f"Response Headers: {json.dumps(dict(response.headers), indent=2)}")
        logging.info(f"Response Content: {response.text}")

        if response.status_code == 200:
            logging.info("HEC connectivity test successful!")
        else:
            logging.error(f"HEC test failed with status code: {response.status_code}")

    except requests.exceptions.SSLError as e:
        logging.error(f"SSL/TLS Error: {str(e)}")
    except requests.exceptions.ConnectionError as e:
        logging.error(f"Connection Error: {str(e)}")
    except Exception as e:
        logging.error(f"Unexpected error: {str(e)}")

def test_batch_events():
    # HEC configuration
    splunk_host = "https://hec.huntress.io"
    hec_token = "<hec token>"

    # Create test batch
    batch = []
    for i in range(5):  # Test with 5 events
        event = {
            "time": int(datetime.datetime.now().timestamp()),
            "host": "test-host",
            "source": f"test-source-{i}",
            "sourcetype": "test-sourcetype",
            "event": f"test event data {i}"
        }
        batch.append(event)

    # HEC request headers
    headers = {
        "Authorization": f"Splunk {hec_token}",
        "Content-Type": "application/json"
    }

    try:
        # Log batch request details
        logging.info("Testing HEC batch event submission")
        logging.info(f"Batch size: {len(batch)}")
        
        # Send batch request
        response = requests.post(
            f"{splunk_host}/services/collector",
            headers=headers,
            json={"events": batch},
            verify=True
        )

        # Log response details
        logging.info(f"Batch Response Status Code: {response.status_code}")
        logging.info(f"Batch Response Content: {response.text}")

        if response.status_code == 200:
            logging.info("Batch event test successful!")
        else:
            logging.error(f"Batch event test failed with status code: {response.status_code}")

    except Exception as e:
        logging.error(f"Batch test error: {str(e)}")

if __name__ == "__main__":
    logging.info("Starting HEC connectivity tests...")
    
    # Test single event
    logging.info("\n=== Testing Single Event Submission ===")
    test_hec_connectivity()
    
    # Test batch events
    logging.info("\n=== Testing Batch Event Submission ===")
    test_batch_events()
