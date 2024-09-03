import pandas as pd
import os
import time
import boto3
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException, NoSuchWindowException, WebDriverException, StaleElementReferenceException, ElementClickInterceptedException
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import datetime
import json
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
from S3_CONFIG import *

s3 = boto3.client(
    's3',
    aws_access_key_id = AWS_ACCESS_KEY_ID,
    aws_secret_access_key = AWS_SECRET_ACCESS_KEY,
    endpoint_url = ENDPOINT_URL
)

bucket_name = BUCKET_NAME
s3_prefix_csv = S3_PREFIX_CSV
s3_prefix_metadata = S3_PREFIX_METADATA 


def write_log(exception):
    with open("/home/phongtranz/Desktop/Scraping_Data/Logs/scraping_tables_log.txt", 'a') as file: # Set your download directory
        file.write(str(datetime.datetime.now()) + "\n=====================\n" + exception + "\n\n")

def write_progress(message):
    with open("/home/phongtranz/Desktop/Scraping_Data/Logs/progress.txt", 'a') as file: # Set your download directory
        file.write(str(datetime.datetime.now()) + "\n=====================\n" + message + "\n\n")

def sanitize_filename(filename):
    """Sanitize the filename to avoid invalid characters."""
    return filename.replace("/", "_").replace("\\", "_")
    
def write_metadata(download_dir, company_name, stock_ticker, title, year, quarter, detailed_report_data_list):
    metadata = {
        "company_name": company_name,
        "stock_ticker": stock_ticker,
        "title": title,
        "year": year,
        "quarter": quarter,
        "detailed_report_data": detailed_report_data_list
    }
    try:
        file_name = f"{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(title)}_metadata.json"
        file_path = os.path.join(download_dir, file_name)
        s3_file_path = f"{s3_prefix_metadata}{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(title)}_metadata.json"

        with open(file_path, 'w') as json_file:
            json.dump(metadata, json_file, indent=4, ensure_ascii=False)
        print(f"Metadata written to {file_path}")
        upload_file_to_s3(s3_file_path, file_path)
        delete_local_files(download_dir)
    except Exception as e:
        message = f"Error writing metadata for company: {company_name}, title: {title}, Exception: {e}"
        write_log(message)

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
    chrome_driver_path = "/usr/local/bin/chromedriver"  # Set your download directory
    service = Service(chrome_driver_path)
    return webdriver.Chrome(service=service, options=chrome_options)
 
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
        print(f"An error occurred while navigating to quarter section: {e}")

def add_to_detailed_report_data_list(detailed_report_data_list, report_names, index, csv_file_path):
    '''
        This function to handle 2 LCTT
    '''
    base_key = report_names[index]
    key = base_key
    if key in detailed_report_data_list:
        key = f"{base_key}_2"
    detailed_report_data_list[key] = csv_file_path
    return detailed_report_data_list

def open_item(driver, download_dir, page_num, first_window, second_window):
    try:
        time.sleep(10)
        all_items = WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, "table[role='presentation'] > tbody > tr[role='row']"))
        )

        item_links = []
        for item in all_items:
            links = item.find_element(By.CSS_SELECTOR, "a.xgl")
            item_links.append(links)
        
        for index in range(len(item_links)):
            time.sleep(7)
            all_items = WebDriverWait(driver, 10).until(
                EC.presence_of_all_elements_located((By.CSS_SELECTOR, "table[role='presentation'] > tbody > tr[role='row']"))
            )

            item_links = []
            for item in all_items:
                links = item.find_element(By.CSS_SELECTOR, "a.xgl")
                item_links.append(links)

            # Click on each item
            item_links[index].click()
            print(f"Page: {page_num}, Current item: {index + 1} has been clicked")
            write_progress(f"Page: {page_num}, Current item: {index + 1} has been clicked")
            
            time.sleep(7)
            # ======== Collecting Metadata ======== 
            tin_cong_bo = driver.find_element(By.CSS_SELECTOR, "div.x5s.p_AFCore.p_AFDefault")
            tin_cong_bo_temp_list = tin_cong_bo.find_elements(By.CSS_SELECTOR, "td[class='xth xtk']")
            # mdn = tin_cong_bo_temp_list[0].text
            company_name = tin_cong_bo_temp_list[1].text
            '''
                Finding stock ticker
            '''
            switch_to_window(driver, second_window)
            search_term = f"mã chứng khoán {company_name}"
            stock_ticker = search_stock(driver, search_term)
            switch_to_window(driver, first_window)
            print(stock_ticker)
            if stock_ticker == None:
                # ======== Back page after scraping enough tables ========
                back_page_button = WebDriverWait(driver, 10).until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, "table.xq2 > tbody > tr > td:nth-of-type(1)"))
                ).find_element(By.CSS_SELECTOR, 'a')
                back_page_button.click() # need to add time.sleep()
                time.sleep(7)
                if page_num == 2:
                    go_to_next_page(driver, page_num)
                elif page_num > 2:
                    for i in range(page_num-1):
                        go_to_next_page(driver, page_num)
                        time.sleep(7)
                # ======== End back page after scraping enough tables ========
                continue
                
            '''
                End
            '''
            title = tin_cong_bo_temp_list[2].text

            chi_tiet_tin_cong_bo = driver.find_element(By.CSS_SELECTOR, "table[style='table-layout:fixed;position:relative;width:1054px;'] > tbody")
            chi_tiet_tin_cong_bo_temp_list = chi_tiet_tin_cong_bo.find_elements(By.CSS_SELECTOR, "tr")
            # year = chi_tiet_tin_cong_bo_temp_list[2].text.split("\n")[-1] # 'Năm tài chính\n*\n2024'
            year = None
            quarter = None
            for detail_info_index in range(len(chi_tiet_tin_cong_bo_temp_list)):
                # if "Năm tài chính" in chi_tiet_tin_cong_bo_temp_list[detail_info_index].text.split("\n"):
                #     year = chi_tiet_tin_cong_bo_temp_list[detail_info_index].text.split("\n")[-1]
                # elif "Quý" in chi_tiet_tin_cong_bo_temp_list[detail_info_index].text.split("\n"):
                #     quarter = chi_tiet_tin_cong_bo_temp_list[detail_info_index].text.split("\n")[-1]
                text_lines = chi_tiet_tin_cong_bo_temp_list[detail_info_index].text.split("\n")
                if "Năm tài chính" in text_lines:
                    year = text_lines[-1]
                elif "Quý" in text_lines:
                    quarter = text_lines[-1]
                
                if year is not None and quarter is not None:
                    break
            # quarter = chi_tiet_tin_cong_bo_temp_list[4].text.split("\n")[-1] # 'Quý\n*\n2'
            print(f"Năm tài chính = {year}")
            print(f"Quý = {quarter}")
            # ======== End of Collecting Metadata ======== 

            # ======== Scraping Tables for each detailed report data: [BCDKT, KQKD, LCTT-TT, LCTT-TT] ======== 
            detailed_report_data_list = {}
            try:
                time.sleep(7)
                # Locate the parent div containing all the <a> tags
                parent_div = driver.find_element(By.CSS_SELECTOR, "#pt2\\:pt1\\:\\:tabh\\:\\:cbc")

                # Find all <a> tags within the parent div
                links = parent_div.find_elements(By.CSS_SELECTOR, "a")

                # Getting report names
                report_names = []
                for i in range(len(links)):
                    print(links[i].text)
                    report_names.append(links[i].text)

                for detailed_index in range(len(links)):
                    # Refetch the parent div and all <a> tags after each click
                    parent_div = WebDriverWait(driver, 10).until(
                        EC.presence_of_element_located((By.CSS_SELECTOR, "#pt2\\:pt1\\:\\:tabh\\:\\:cbc"))
                    )
                    links = parent_div.find_elements(By.CSS_SELECTOR, "a")

                    # for i in range(len(links)):
                    #     print(links[i].text)
                    time.sleep(5)
                    # Click the current link
                    links[detailed_index].click()
                    time.sleep(7)
                    
                    # Wait until the page updates by checking for an element with "p_AFSelected" in class name
                    WebDriverWait(driver, 10).until(
                        EC.presence_of_element_located((By.CSS_SELECTOR, "div.p_AFSelected"))
                    )

                    detailed_report_data_name = report_names[detailed_index] # [BCDKT, KQKD, LCTT-TT, LCTT-TT] 
                    csv_file_path = scrape_table(driver, download_dir, year, quarter, company_name, detailed_report_data_name, title)

                    # detailed_report_data_list[report_names[index]] = csv_file_path
                    detailed_report_data_list = add_to_detailed_report_data_list(detailed_report_data_list, report_names, detailed_index, csv_file_path)
                    print(f"Clicked on {detailed_report_data_name}, Page: {page_num}, Item: {index + 1} has been clicked")
            except Exception as e:
                print(f"An error occurred while scraping tables for {report_names[index]}, Page: {page_num}, Item: {index + 1} : {e}")

            time.sleep(5)

            delete_local_files(download_dir)
            # ======== End of Scraping Tables for each detailed report data: [BCDKT, KQKD, LCTT-TT, LCTT-TT] ========

            metadata_dir = "/home/phongtranz/Desktop/Scraping_Data/Metadata_files_CSV" # Set your download directory
            write_metadata(metadata_dir, company_name, stock_ticker, title, year, quarter, detailed_report_data_list)
            # TODO: Upload to S3
            time.sleep(5)
            # ======== End of storing metadata ========

            # ======== Back page after scraping enough tables ========
            back_page_button = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "table.xq2 > tbody > tr > td:nth-of-type(1)"))
            ).find_element(By.CSS_SELECTOR, 'a')
            back_page_button.click() # need to add time.sleep()
            if page_num == 2:
                go_to_next_page(driver, page_num)
            elif page_num > 2:
                for i in range(page_num-1):
                    go_to_next_page(driver, page_num)
                    time.sleep(5)
            # ======== End back page after scraping enough tables ========
            
        '''
        ========= TESTING PURPOSE ONLY ==========
        '''

        '''
        ========== END OF TESTING ===========
        '''

    except Exception as e:
        exception = f"An error occurred while opening item Page: {page_num}, Item: {index + 1}: {e}, on {page_num} page"
        write_log(exception)

def upload_file_to_s3(s3_file_path, csv_file_path):
    """
    Uploads PDF files from a local folder to an S3 bucket.

    Args:
        download_dir (str): Path to the local folder containing .jsonl.zst files.
        bucket_name (str): Name of the S3 bucket.
        s3_folder (str): S3 folder path where files will be uploaded.
    """

    # Iterate through all files in the specified local folder
    # for filename in os.listdir(download_dir):

    # Construct the full local file path
    # local_file_path = os.path.join(download_dir, filename)
    try:
        # Upload the file to S3
        # s3.upload_file(local_file_path, bucket_name, s3_file_path, Callback=upload_progress)
        s3.upload_file(csv_file_path, bucket_name, s3_file_path)
        # print(f"\n=============\nCompleted uploading {filename} to {bucket_name}/{s3_file_path}\n=============\n")
        # os.remove(local_file_path)
    except FileNotFoundError:
        print(f"The file {csv_file_path} was not found")
    except NoCredentialsError:
        print("Credentials not available")
    except PartialCredentialsError:
        print("Incomplete credentials provided")
    except Exception as e:
        print(f"Failed to upload {csv_file_path}: {str(e)}")

def delete_local_files(download_dir):
    for filename in os.listdir(download_dir):
         # Construct the full local file path
        local_file_path = os.path.join(download_dir, filename)
        try:
            os.remove(local_file_path)
        except FileNotFoundError:
            print(f"The file {local_file_path} was not found")

def save_to_csv(columns, table_data, file_path):
    try:
        # Create DataFrame from table data
        df = pd.DataFrame(table_data, columns=columns)
        
        
        # Save DataFrame to CSV file
        df.to_csv(file_path, index=False)
        
        print(f"Data has been successfully exported to {file_path}")
    
    except Exception as e:
        print(f"An error occurred while saving to CSV: {e}")

def scrape_table(driver, download_dir, year, quarter, company_name, detailed_report_data_name, title):
    try:
        # Wait for the elements to be present
        WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, "div.x14x"))
        )

        divs = driver.find_elements(By.CSS_SELECTOR, "div.x14x")
        # Table column names
        # DONE: However, need to open full screen browser
        columns = divs[0].text.split("\n")

        # Table contents
        body = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "div.xtc.xsz > div.x14p > table"))
        )

        table_data = extract_table_data(body)

        csv_file_path = f"{download_dir}/{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(detailed_report_data_name)}.csv"
        """
        constructs the initial file path and checks for its existence. If the file already exists,
        it modifies the file path by appending "_2" to the filename. 
        The function then returns the unique file path.
        """
        if os.path.exists(csv_file_path):
            csv_file_path = f"{download_dir}/{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(detailed_report_data_name)}_2.csv"
            s3_file_path = f"{s3_prefix_csv}{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(detailed_report_data_name)}_2.csv"
        else:
            s3_file_path = f"{s3_prefix_csv}{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(detailed_report_data_name)}.csv"
        # Save data to CSV
        save_to_csv(columns, table_data, csv_file_path)
        upload_file_to_s3(s3_file_path, csv_file_path)
        # return csv_file_path
        return s3_file_path
        

    except Exception as e:
        exception = f"An error occurred with item: {e}"
        write_log(exception)

def extract_table_data(table_element):
    data = []
    
    try:
        rows = table_element.find_elements(By.CSS_SELECTOR, "tr[role='row']")
        
        for row in rows:
            # Find all <td> elements in the row
            cells = row.find_elements(By.CSS_SELECTOR, "td")
            
            # Extract text from each <td> and clean it
            row_data = [cell.text for cell in cells]
            
            # Append the row data to the result list
            data.append(row_data)
        
        print("Table data extracted successfully.")
        return data
    
    except Exception as e:
        exception = f"An error occurred while extracting table data: {e}"
        write_log(exception)


def go_to_next_page(driver, page_num):
    """Navigate to the next page."""
    global break_page
    try:
        print(f"\n=============\nProcessing page {page_num}\n=============\n")
        next_page = WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "table[id='pt9:t1::nb_cnt'] > tbody > tr > td > a.x14i"))
        )
        driver.execute_script("arguments[0].scrollIntoView(true);", next_page)
        driver.execute_script("arguments[0].click();", next_page)
        # return True
    except (NoSuchElementException, TimeoutException):
        break_page = True
        print("No more pages to navigate or timeout occured.")

def navigate_and_click(driver, download_dir, first_window, second_window):
    page_num = 1
    # ===== testing =====
    # page_num += 1
    # ===== end testing =====
    global break_page
    break_page = False
    # ===== testing =====
    for i in range(8):
        page_num += 1
        go_to_next_page(driver, page_num)
        time.sleep(7)
    # go_to_next_page(driver, page_num)
    print(f"Page num: {page_num}")
    # ===== end testing =====
    while True:
        time.sleep(7)
        # go_to_next_page(driver, page_num)
        open_item(driver, download_dir, page_num, first_window, second_window)
        with open("/home/phongtranz/Desktop/Scraping_Data/page_visisted.txt", 'a') as file: # Set your download directory
            file.write(f"Page {page_num} has been done\n=====================\n")
        page_num += 1
        go_to_next_page(driver, page_num)
        if page_num == 100:
            break
        if break_page:
            break

def start_searching(driver):
    try:
        search_box = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "textarea.gLFyf"))
        )
        # search_box.click()
        return search_box
    except Exception as e:
        print(f"Error occurs when start searching: {e}")

def search_stock(driver, company_name):
    try:
        time.sleep(1)
        search_box = start_searching(driver)

        search_box.clear()

        search_box.send_keys(company_name)

        # Submit the search by simulating the Enter key
        search_box.send_keys(Keys.RETURN)

        time.sleep(3)

        ticker = get_result(driver)
        return ticker
    except Exception as e:
        print(f"Error occurs during search_stock: {e}")
        return None
    
def get_result(driver):
    try:
        # Locate the <b> tag inside the complex HTML structure
        b_element = driver.find_element(By.CSS_SELECTOR, "div.LGOjhe span.hgKElc b")
        
        # Get the text inside the <b> tag
        b_text = b_element.text
        return b_text
    
    except Exception as e:
        print(f"An error occurred: {e}")
        return None


def open_two_pages(driver, url1, url2):
    """Open two pages in separate windows."""
    # Open the first URL in the first window
    driver.get(url1)
    first_window = driver.current_window_handle
    
    # Open a new window and navigate to the second URL
    driver.execute_script("window.open('');")  # Open a new blank window
    driver.switch_to.window(driver.window_handles[1])  # Switch to the new window
    driver.get(url2)
    second_window = driver.current_window_handle

    # Return the handles of both windows
    return first_window, second_window

def switch_to_window(driver, window_handle):
    """Switch to a specified window."""
    driver.switch_to.window(window_handle)
    # print(f"Switched to window with handle: {window_handle}")
    time.sleep(2)  # Simulate some operations

def main():
    download_dir = "/home/phongtranz/Desktop/Scraping_Data/Table_Results_CSV"  # Set your download directory
    os.makedirs(download_dir, exist_ok=True)
    page_url = "https://congbothongtin.ssc.gov.vn/"
    stock_finder_url = 'https://www.google.com/search?q=m%C3%A3+ch%E1%BB%A9ng+kho%C3%A1n+techcombank&sca_esv=48c265a38ff002be&sca_upv=1&hl=en&sxsrf=ADLYWIIilAlA0ctf0TzWSLQfEEMAsnHrTg%3A1725190026085&source=hp&ei=ik_UZsHYApzi2roPu_2IgAQ&iflsig=AL9hbdgAAAAAZtRdmvCvpzx2t3TUHig8J2agKb7yLzxP&oq=&gs_lp=Egdnd3Mtd2l6IgAqAggAMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCSJ0zUABYAHABeACQAQCYAQCgAQCqAQC4AQHIAQCYAgGgAguoAgqYAwuSBwExoAcA&sclient=gws-wiz'
 
    driver = setup_driver(download_dir)
    try:
        # Open the two pages
        first_window, second_window = open_two_pages(driver, page_url, stock_finder_url)
        # Switch to the second window
        # switch_to_window(driver, second_window)
        # google_search = start_searching(driver)

        # Switch to the first window
        switch_to_window(driver, first_window)
        navigate_to_quarter_section(driver)
        navigate_and_click(driver, download_dir, first_window, second_window)
    finally:
        driver.quit()
if __name__ == "__main__":
    main()