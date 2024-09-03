import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import os
from S3_CONFIG import *
import json

s3_client = boto3.client(
    's3',
    aws_access_key_id = AWS_ACCESS_KEY_ID,
    aws_secret_access_key = AWS_SECRET_ACCESS_KEY,
    endpoint_url = ENDPOINT_URL
)

bucket_name = BUCKET_NAME
s3_prefix_csv = S3_PREFIX_CSV
s3_prefix_metadata = S3_PREFIX_METADATA 

# The download function provided earlier
def download_file_from_s3(bucket_name, s3_key, local_dir):
    """
    Downloads a specified file from a private S3 bucket and saves it to a local directory.

    :param bucket_name: Name of the S3 bucket.
    :param s3_key: S3 key of the file to download.
    :param local_dir: Local directory where the file will be saved. The directory structure will follow the S3 key.
    :param access_key: AWS access key.
    :param secret_key: AWS secret key.
    """
    try:
        # Construct the local file path
        local_file_path = os.path.join(local_dir, os.path.basename(s3_key))
        
        # Ensure the local directory exists
        os.makedirs(os.path.dirname(local_file_path), exist_ok=True)
        
        # Download the file from S3
        s3_client.download_file(bucket_name, s3_key, local_file_path)
        print(f"File downloaded successfully: {local_file_path}")
        
    except NoCredentialsError:
        print("Credentials not available")
    except PartialCredentialsError:
        print("Incomplete credentials provided")
    except Exception as e:
        print(f"An error occurred: {e}")

def download_files_from_detailed_report_data(json_data, bucket_name, local_dir):
    """
    Downloads all files listed in the 'detailed_report_data' section of the JSON data.

    :param json_data: JSON object containing report data.
    :param bucket_name: S3 bucket name.
    :param local_dir: Local directory to save the files.
    :param access_key: AWS access key.
    :param secret_key: AWS secret key.
    """
    detailed_report_data = json_data.get('detailed_report_data', {})
    
    for report_name, s3_key in detailed_report_data.items():
        print(f"Downloading {report_name} from S3 key: {s3_key}")
        download_file_from_s3(bucket_name, s3_key, local_dir)

def download_files_from_s3_prefix(bucket_name, prefix, local_dir):
    """
    Downloads all files from a specified folder prefix in a private S3 bucket.

    :param bucket_name: Name of the S3 bucket.
    :param prefix: S3 prefix (folder path) from which to download files.
    :param local_dir: Local directory where the files will be saved.
    :param access_key: AWS access key.
    :param secret_key: AWS secret key.
    """
    try:   
        # List objects under the specified prefix
        response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
        
        if 'Contents' in response:
            for obj in response['Contents']:
                # Extract the S3 key (file path)
                s3_key = obj['Key']
                
                # Construct local file path
                local_file_path = os.path.join(local_dir, os.path.relpath(s3_key, prefix))
                
                # Ensure the local directory exists
                os.makedirs(os.path.dirname(local_file_path), exist_ok=True)
                
                # Download the file
                s3_client.download_file(bucket_name, s3_key, local_file_path)
                print(f"File downloaded: {local_file_path}")
                with open(local_file_path, 'r', encoding='utf-8') as file:
                    json_data = json.load(file)
                csv_dir = '/home/phongtranz/Desktop/Scraping_Data/S3_Download/csv' # Set your download directory
                download_files_from_detailed_report_data(json_data, bucket_name, csv_dir)
                # return local_file_path
        else:
            print("No files found for the specified prefix.")
        
    except NoCredentialsError:
        print("Credentials not available")
    except PartialCredentialsError:
        print("Incomplete credentials provided")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
# Example usage:
    download_files_from_s3_prefix(bucket_name, s3_prefix_metadata, '/home/phongtranz/Desktop/Scraping_Data/S3_Download/metadata') # Set your download directory
    # local_dir = '/home/phongtranz/Desktop/Scraping_Data/S3_Download'
    # with open(json_data_file_path, 'r', encoding='utf-8') as file:
    #     json_data = json.load(file)

    # download_files_from_detailed_report_data(json_data, bucket_name, local_dir)
        
if __name__ == '__main__':
    main()
