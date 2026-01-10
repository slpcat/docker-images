from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.binary_location = '/usr/local/bin/chrome-headless-shell'

service = Service('/usr/local/bin/chromedriver')
driver = webdriver.Chrome(service=service, options=options)

driver.get('https://www.baidu.com')
print(driver.title)
driver.quit()
