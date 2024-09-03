import requests
import pandas as pd # type: ignore
# from bs4 import BeautifulSoup
import os
import time
import tqdm
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException, NoSuchWindowException, WebDriverException, StaleElementReferenceException, ElementClickInterceptedException
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import datetime
import json

# url = "https://congbothongtin.ssc.gov.vn/faces/NewsSearch"

def write_log(exception):
    with open("/home/phongtranz/Desktop/Scraping_Data/Logs/scraping_tables_log.txt", 'a') as file:
        file.write(str(datetime.datetime.now()) + "\n=====================\n" + exception + "\n\n")

def write_progress(message):
    with open("/home/phongtranz/Desktop/Scraping_Data/Logs/progress.txt", 'a') as file:
        file.write(str(datetime.datetime.now()) + "\n=====================\n" + message + "\n\n")

def sanitize_filename(filename):
    """Sanitize the filename to avoid invalid characters."""
    return filename.replace("/", "_").replace("\\", "_")
    
def write_metadata(download_dir, company_name, title, year, quarter, detailed_report_data_list):
    metadata = {
        "company_name": company_name,
        "title": title,
        "year": year,
        "quarter": quarter,
        "detailed_report_data": detailed_report_data_list
    }
    try:
        file_name = f"{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(title)}_metadata.json"
        file_path = os.path.join(download_dir, file_name)

        with open(file_path, 'w') as json_file:
            json.dump(metadata, json_file, indent=4, ensure_ascii=False)
        print(f"Metadata written to {file_path}")
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
    chrome_driver_path = "/usr/local/bin/chromedriver"  # Adjust this path to your chromedriver executable
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

def add_to_detailed_report_data_list(detailed_report_data_list, report_names, index, markdown_file_path):
    '''
        This function to handle 2 LCTT
    '''
    base_key = report_names[index]
    key = base_key
    if key in detailed_report_data_list:
        key = f"{base_key}_2"
    detailed_report_data_list[key] = markdown_file_path
    return detailed_report_data_list

def open_item(driver, download_dir, page_num):
    try:

        all_items = WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, "table[role='presentation'] > tbody > tr[role='row']"))
        )

        item_links = []
        for item in all_items:
            links = item.find_element(By.CSS_SELECTOR, "a.xgl")
            item_links.append(links)
        
        for index in range(len(item_links)):
            time.sleep(10)
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
            
            time.sleep(10)
            # ======== Collecting Metadata ======== 
            tin_cong_bo = driver.find_element(By.CSS_SELECTOR, "div.x5s.p_AFCore.p_AFDefault")
            tin_cong_bo_temp_list = tin_cong_bo.find_elements(By.CSS_SELECTOR, "td[class='xth xtk']")
            # mdn = tin_cong_bo_temp_list[0].text
            company_name = tin_cong_bo_temp_list[1].text
            title = tin_cong_bo_temp_list[2].text

            chi_tiet_tin_cong_bo = driver.find_element(By.CSS_SELECTOR, "table[style='table-layout:fixed;position:relative;width:1054px;'] > tbody")
            chi_tiet_tin_cong_bo_temp_list = chi_tiet_tin_cong_bo.find_elements(By.CSS_SELECTOR, "tr")
            year = chi_tiet_tin_cong_bo_temp_list[2].text.split("\n")[-1] # 'Năm tài chính\n*\n2024'
            quarter = chi_tiet_tin_cong_bo_temp_list[4].text.split("\n")[-1] # 'Quý\n*\n2'
            # ======== End of Collecting Metadata ======== 

            # ======== Scraping Tables for each detailed report data: [BCDKT, KQKD, LCTT-TT, LCTT-TT] ======== 
            detailed_report_data_list = {}
            try:
                time.sleep(10)
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
                    # TODO: change this to markdown
                    markdown_file_path = scrape_table(driver, download_dir, year, quarter, company_name, detailed_report_data_name, title)

                    # detailed_report_data_list[report_names[index]] = markdown_file_path
                    detailed_report_data_list = add_to_detailed_report_data_list(detailed_report_data_list, report_names, detailed_index, markdown_file_path)
                    print(f"Clicked on {report_names[detailed_index]}, Page: {page_num}, Item: {index + 1} has been clicked")
            except Exception as e:
                print(f"An error occurred while scraping tables for {report_names[index]}, Page: {page_num}, Item: {index + 1} : {e}")

            time.sleep(5)
            # ======== End of Scraping Tables for each detailed report data: [BCDKT, KQKD, LCTT-TT, LCTT-TT] ========
            

            # ======== Storing metadata ========
            """
            =====
            Expected json file, for example:
            =====
            {
            "company_name" : "CTCP Tập đoàn Hóa chất Đức Giang"
            "title": "Báo cáo tài chính hợp nhất quý 2/ năm 2024"
            "year": "2024"
            "quarter": "2"
            "detailed_report_data":{
                            "BCDKT": "file_path",
                            "KQKD": "file_path",
                            "LCTT-TT": "file_path",
                            "LCTT-TT": "file_path" 
                }
            }

            {
            "company_name" : company_name
            "title": title
            "year": year
            "quarter": quarter
            "detailed_report_data": detailed_report_data_list
            }
            """
            metadata_dir = "/home/phongtranz/Desktop/Scraping_Data/Metadata_files_Markdown"
            write_metadata(metadata_dir, company_name, title, year, quarter, detailed_report_data_list)
            time.sleep(5)
            # ======== End of storing metadata ========

            # ======== Back page after scraping enough tables ========
            back_page_button = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "table.xq2 > tbody > tr > td:nth-of-type(1)"))
            ).find_element(By.CSS_SELECTOR, 'a')
            # TODO: Need to handle to go current page.
            back_page_button.click() # need to add time.sleep()
            if page_num == 2:
                go_to_next_page(driver, page_num)
            elif page_num > 2:
                for i in range(page_num-1):
                    go_to_next_page(driver, page_num)
                    time.sleep(5)
            # ======== End back page after scraping enough tables ========

    except Exception as e:
        exception = f"An error occurred while opening item Page: {page_num}, Item: {index + 1}: {e}, on {page_num} page"
        write_log(exception)

def save_to_markdown(columns, table_data, file_path):
    try:
        # Create markdown header separator
        column_widths = [len(col) for col in columns]
        for row in table_data:
            for i, cell in enumerate(row):
                column_widths[i] = max(column_widths[i], len(cell))

        # Format headers and data rows to markdown
        markdown_lines = []
        header_line = '| ' + ' | '.join(f'{col:<{column_widths[i]}}' for i, col in enumerate(columns)) + ' |'
        separator_line = '| ' + ' | '.join('-' * column_widths[i] for i in range(len(columns))) + ' |'

        markdown_lines.append(header_line)
        markdown_lines.append(separator_line)

        for row in table_data:
            row_line = '| ' + ' | '.join(f'{cell:<{column_widths[i]}}' for i, cell in enumerate(row)) + ' |'
            markdown_lines.append(row_line)

        # Write to markdown file
        with open(file_path, 'w') as markdown_file:
            markdown_file.write('\n'.join(markdown_lines))
        
        print(f"Data has been successfully exported to {file_path}")
    
    except Exception as e:
        print(f"An error occurred while saving to Markdown: {e}")


def scrape_table(driver, download_dir, year, quarter, company_name, detailed_report_data_name, title):
    try:
        # Wait for the elements to be present
        WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, "div.x14x"))
        )

        divs = driver.find_elements(By.CSS_SELECTOR, "div.x14x")
        # Table column names
        columns = divs[0].text.split("\n")

        # Table contents
        body = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "div.xtc.xsz > div.x14p > table"))
        )

        table_data = extract_table_data(body)

        markdown_file_path = f"{download_dir}/{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(detailed_report_data_name)}.md"
        
        if os.path.exists(markdown_file_path):
            markdown_file_path = f"{download_dir}/{year}_{quarter}_{sanitize_filename(company_name)}_{sanitize_filename(detailed_report_data_name)}_2.md"
        
        # Save data to Markdown
        save_to_markdown(columns, table_data, markdown_file_path)
        return markdown_file_path

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

def navigate_and_click(driver, download_dir):
    page_num = 1
    # ===== testing =====
    # page_num += 2
    # ===== end testing =====
    global break_page
    break_page = False
    # ===== testing =====
    # go_to_next_page(driver, page_num)
    # time.sleep(5)
    # go_to_next_page(driver, page_num)
    # ===== end testing =====
    while True:
        time.sleep(10)
        # go_to_next_page(driver, page_num)
        open_item(driver, download_dir, page_num)
        page_num += 1
        go_to_next_page(driver, page_num)
        if break_page:
            break

# def go_to_next_page(driver, page_num):
#     """Navigate to the next page."""
#     global break_page
#     try:
#         print(f"\n=============\nProcessing page {page_num}\n=============\n")
#         with open("/home/phongtranz/Desktop/Scraping_Data/page_progress.txt", "a") as file:
#             file.write(f"\n=============\nProcessing page {page_num}\n=============\n")
#         next_page = WebDriverWait(driver, 30).until(
#             EC.element_to_be_clickable((By.CSS_SELECTOR, "table[id='pt9:t1::nb_cnt'] > tbody > tr > td > a.x14i"))
#         )
#         driver.execute_script("arguments[0].scrollIntoView(true);", next_page)
#         driver.execute_script("arguments[0].click();", next_page)
#         # return True
#     except (NoSuchElementException, TimeoutException):
#         break_page = True
#         print("No more pages to navigate or timeout occured.")
#         # return False

def main():
    download_dir = "/home/phongtranz/Desktop/Scraping_Data/Table_Results_Markdown"  # Set your download directory
    os.makedirs(download_dir, exist_ok=True)
    page_url = "https://congbothongtin.ssc.gov.vn/"
 
    driver = setup_driver(download_dir)
    try:
        driver.get(page_url)
        navigate_to_quarter_section(driver)
        navigate_and_click(driver, download_dir)
    finally:
        driver.quit()
if __name__ == "__main__":
    main()