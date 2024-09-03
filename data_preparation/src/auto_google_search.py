import os
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException, NoSuchWindowException, WebDriverException, StaleElementReferenceException, ElementClickInterceptedException
from selenium.webdriver.common.keys import Keys

def setup_driver():
    """Set up Chrome driver with specific download preferences for handling PDFs automatically."""
    chrome_options = webdriver.ChromeOptions()
    chrome_driver_path = "/usr/local/bin/chromedriver"  # Adjust this path to your chromedriver executable
    service = Service(chrome_driver_path)
    return webdriver.Chrome(service=service, options=chrome_options)

def start_searching(driver):
    try:
        search_box = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, "textarea.gLFyf"))
        )
        search_box.click()
        return search_box
    except Exception as e:
        print(f"Error occurs when start searching: {e}")

def search_stock(driver, company_name, search_box):
    try:
        time.sleep(1)

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
    # ssc_url = 'https://congbothongtin.ssc.gov.vn/'
    page_url = 'https://www.google.com/search?q=m%C3%A3+ch%E1%BB%A9ng+kho%C3%A1n+techcombank&sca_esv=48c265a38ff002be&sca_upv=1&hl=en&sxsrf=ADLYWIIilAlA0ctf0TzWSLQfEEMAsnHrTg%3A1725190026085&source=hp&ei=ik_UZsHYApzi2roPu_2IgAQ&iflsig=AL9hbdgAAAAAZtRdmvCvpzx2t3TUHig8J2agKb7yLzxP&oq=&gs_lp=Egdnd3Mtd2l6IgAqAggAMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCMgcQIxgnGOoCSJ0zUABYAHABeACQAQCYAQCgAQCqAQC4AQHIAQCYAgGgAguoAgqYAwuSBwExoAcA&sclient=gws-wiz'
    company_name = 'mã chứng khoán Hoàng Anh Gia Lai'
    driver = setup_driver()

    try:
        driver.get(page_url)
        search_box = start_searching(driver)
        print(search_stock(driver, company_name, search_box))
        
    finally:
        driver.quit()


if __name__ == '__main__':
    main()


