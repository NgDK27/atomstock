import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import os
import shutil
from tqdm import tqdm
from tika import parser
import yaml # type: ignore

config_file_path = "/media/phongtranz/New Volume/Users/Admin/Documents/Capstone/Scraping_Data/config.yaml"

with open(config_file_path, "r", encoding="utf-8") as cfg_file:
    config = yaml.safe_load(cfg_file)

bucket_name = config["BUCKET_NAME"]
service = config["SERVICE"]

s3_access_key = config["AWS_S3_CONFIG"]["ACCESS_KEY"]
s3_secret_key = config["AWS_S3_CONFIG"]["SECRET_KEY"]
s3_endpoint = config["AWS_S3_CONFIG"]["ENDPOINT"]

def get_pdf_page_count(pdf_path):
    try:
        parsed_pdf = parser.from_file(pdf_path)
        metadata = parsed_pdf.get('metadata', {})
        return int(metadata.get('xmpTPg:NPages', 0))
    except Exception as e:
        print(f"Failed to get page count for {pdf_path}: {e}")
        return 0
    
def list_all_files(bucket_name, prefix, s3_client):
    pdf_files = []
    paginator = s3_client.get_paginator('list_objects_v2')
    pages = paginator.paginate(Bucket=bucket_name, Prefix=prefix)

    for page in pages:
        for obj in page.get('Contents', []):
            pdf_files.append(obj['Key'])
    
    return pdf_files

def download_files_from_s3(download_dir, bucket_name, files, s3_client, max_files=50):
    downloaded_files = []
    try:
        if not os.path.exists(download_dir):
            os.makedirs(download_dir)
        
        for key in files[:max_files]:
            file_name = os.path.basename(key)
            download_file_path = os.path.join(download_dir, file_name)
            
            file_size = s3_client.head_object(Bucket=bucket_name, Key=key)['ContentLength']
            with tqdm(total=file_size, unit='B', unit_scale=True, desc=file_name, ascii=True, ncols=100) as pbar:
                s3_client.download_file(bucket_name, key, download_file_path, Callback=pbar.update)
            
            downloaded_files.append(download_file_path)
        
    except NoCredentialsError:
        print("Credentials not available.")
    except PartialCredentialsError:
        print("Incomplete credentials provided.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return downloaded_files

def process_and_count_pages(download_dir, bucket_name, prefix, access_key, secret_key, endpoint_url):
    total_pages = 0
    processed_files = 0
    session = boto3.session.Session(
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key
    )
    s3_client = session.client('s3', endpoint_url=endpoint_url)
    
    pdf_files = list_all_files(bucket_name, prefix, s3_client)
    print(f"Number of files found: {len(pdf_files)}")

    while pdf_files:
        batch_files = pdf_files[:50]
        pdf_files = pdf_files[50:]
        
        downloaded_files = download_files_from_s3(download_dir, bucket_name, batch_files, s3_client)
        
        for pdf_file in downloaded_files:
            total_pages += get_pdf_page_count(pdf_file)
        
        # Clean up the downloaded files
        for file_path in downloaded_files:
            os.remove(file_path)
        
        processed_files += len(downloaded_files)
        print(f"Total processed files: {processed_files}")

    return total_pages

def main():
    prefix = config["S3_PREFIX"]["CONGBOTHONGTIN_SSC"]
    download_dir = "/media/phongtranz/New Volume/Users/Admin/Documents/Capstone/Scraping_Data/S3_Download"
    
    total_pages = process_and_count_pages(download_dir, bucket_name, prefix, s3_access_key, s3_secret_key, s3_endpoint)
    print(f'Total number of pages in all PDF files in S3: {total_pages}')

if __name__ == "__main__":
    main()
