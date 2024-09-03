import os
import time
import requests
import tqdm
import boto3
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException, NoSuchWindowException, WebDriverException, StaleElementReferenceException, ElementClickInterceptedException
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
from S3_CONFIG import *


s3 = boto3.client(
    's3',
    aws_access_key_id = AWS_ACCESS_KEY_ID,
    aws_secret_access_key = AWS_SECRET_ACCESS_KEY,
    endpoint_url = ENDPOINT_URL
)

bucket_name = BUCKET_NAME
s3_prefix = S3_PREFIX_CSV


def setup_driver(download_dir):
    """Set up Chrome driver with specific download preferences for handling PDFs automatically."""
    chrome_options = webdriver.ChromeOptions()
    prefs = {
        "download.default_directory": download_dir,
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "plugins.always_open_pdf_exaternally": True  # Ensures PDFs download automatically
    }
    chrome_options.add_experimental_option("prefs", prefs)
    # chrome_options.add_argument("--headless")
    chrome_driver_path = "/usr/local/bin/chromedriver"  # Adjust this path to your chromedriver executable
    service = Service(chrome_driver_path)
    return webdriver.Chrome(service=service, options=chrome_options)
 
def wait_for_downloads(download_dir, timeout=600):
    """Wait for all downloads to complete within the specified timeout."""
    seconds = 0
    while seconds < timeout:
        time.sleep(1)
        if not any(fname.endswith('.crdownload') for fname in os.listdir(download_dir)):
            return True
        seconds += 1
    return False
# DONE
def navigate_to_quarter_section(driver):
    try:
        # Click on the dropdown button
        dropdown_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "pt9:smc2::drop"))
        )
        dropdown_button.click()

        # Wait for the dropdown list to be visible
        dropdown_list = WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.CLASS_NAME, "x18w"))
        )

        # Find and click on "Báo cáo tài chính Hợp nhất - Quý" option
        quarter_option = dropdown_list.find_element(
            By.XPATH, "//label[contains(text(), 'Báo cáo tài chính Hợp nhất - Quý')]/input"
        )
        quarter_option.click()

        # Wait and click on the search button
        search_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, "//div[@id='pt9:b1']/a[@role='button']"))
        )
        search_button.click()

        time.sleep(10)

    except Exception as e:
        print(f"An error occurred: {e}")

def download_documents(driver, download_dir):
    try:
        # Wait until the documents are visible on the page
        document_links = WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, "tr.x14o > td > span.x221 > a.xgn"))
            
        )
        # Scroll each document link into view and click to initiate download
        for link in document_links:
            try:

                driver.execute_script("arguments[0].scrollIntoView(true);", link)
                WebDriverWait(driver, 10).until(EC.element_to_be_clickable(link)).click()
                # Wait for the download to start before clicking the next link
                # time.sleep(5)

                # Wait for the download to complete before clicking the next link
                wait_for_download_to_complete(download_dir)
            except (StaleElementReferenceException, ElementClickInterceptedException) as e:
                print(f"An error occurred with link {link.get_attribute('id')}: {e}")
                # Re-locate the document links if the page has changed or if click is intercepted
                document_links = WebDriverWait(driver, 10).until(
                    EC.presence_of_all_elements_located((By.CSS_SELECTOR, "tr.x14o > td > span.x221 > a.xgn"))
                    
                )
                continue # Skip to the next link

        print("All documents have been clicked for download.")

    except Exception as e:
        print(f"An error occurred: {e}")

def wait_for_download_to_complete(download_dir, timeout=300):
    """
    Waits for a file to be completely downloaded.
    """
    start_time = time.time()
    while True:
        files = os.listdir(download_dir)
        download_in_progress = any(file.endswith('.crdownload') for file in files)

        if not download_in_progress:
            time.sleep(2)  # Wait a bit to ensure the download process is fully complete
            return
        
        if time.time() - start_time > timeout:
            raise TimeoutError("Download took too long and timed out.")
        
        time.sleep(1)

def navigate_and_download(driver, download_dir):
    page_num = 1 # has been on 74
    # for i in range(74):
    #     go_to_next_page(driver, page_num)
    #     page_num += 1
    #     time.sleep(10)
    global break_page
    break_page = False
    while True:
        time.sleep(10)
        download_documents(driver, download_dir)
        upload_file_to_s3(download_dir, bucket_name, s3_prefix)
        page_num += 1
        go_to_next_page(driver, page_num)
        if break_page:
            break


def go_to_next_page(driver, page_num):
    """Navigate to the next page."""
    global break_page
    try:
        print(f"\n=============\nProcessing page {page_num}\n=============\n")
        with open("/home/phongtranz/Desktop/Scraping_Data/page_progress.txt", "a") as file:
            file.write(f"\n=============\nProcessing page {page_num}\n=============\n")
        next_page = WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "table[id='pt9:t1::nb_cnt'] > tbody > tr > td > a.x14i"))
        )
        driver.execute_script("arguments[0].scrollIntoView(true);", next_page)
        driver.execute_script("arguments[0].click();", next_page)
        # return True
    except (NoSuchElementException, TimeoutException):
        break_page = True
        print("No more pages to navigate or timeout occured.")
        # return False

def upload_file_to_s3(download_dir, bucket_name, s3_folder):
    """
    Uploads PDF files from a local folder to an S3 bucket.

    Args:
        download_dir (str): Path to the local folder containing .jsonl.zst files.
        bucket_name (str): Name of the S3 bucket.
        s3_folder (str): S3 folder path where files will be uploaded.
    """

    # Iterate through all files in the specified local folder
    for filename in os.listdir(download_dir):
        # Check if the file is a .jsonl.zst
        if not filename.endswith(".crdownload"):
            """Upload file to S3 with progress bar"""
        # file_size = os.path.getsize(os.path.join(download_dir, filename))
        # progress = tqdm(total=file_size, unit='B', unit_scale=True, desc=f"Uploading {filename}")

        # def upload_progress(chunk):
        #     progress.update(chunk)

            # Construct the full local file path
            local_file_path = os.path.join(download_dir, filename)
            # Construct the full S3 file path
            # s3_file_path = os.path.join(s3_folder, filename)
            s3_file_path = f"{s3_folder}/{filename}"
            try:
                # Upload the file to S3
                # s3.upload_file(local_file_path, bucket_name, s3_file_path, Callback=upload_progress)
                s3.upload_file(local_file_path, bucket_name, s3_file_path)
                print(f"\n=============\nCompleted uploadiing {filename} to {bucket_name}/{s3_file_path}\n=============\n")
                os.remove(local_file_path)
            except FileNotFoundError:
                print(f"The file {local_file_path} was not found")
            except NoCredentialsError:
                print("Credentials not available")
            except PartialCredentialsError:
                print("Incomplete credentials provided")
            except Exception as e:
                print(f"Failed to upload {filename}: {str(e)}")

            # progress.close()

def main():
    download_dir = "/home/phongtranz/Desktop/Scraping_Data/Financial_Statements_Data_Dir"  # Set your download directory
    os.makedirs(download_dir, exist_ok=True)
    page_url = "https://congbothongtin.ssc.gov.vn/"
 
    driver = setup_driver(download_dir)
    try:
        driver.get(page_url)
        navigate_to_quarter_section(driver)
        navigate_and_download(driver, download_dir)
    finally:
        driver.quit()
if __name__ == "__main__":
    main()