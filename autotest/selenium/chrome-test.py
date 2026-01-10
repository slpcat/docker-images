from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

opts = Options()
# 关键参数组合：无头 + 禁用 GPU + 禁用沙箱 + 禁用 dev-shm + 禁用 dbus
opts.add_argument("--headless=new")          # 109+ 推荐写法
opts.add_argument("--no-sandbox")            # 容器/无 root 必须
opts.add_argument("--disable-dev-shm-usage") # 避免 /dev/shm 太小
opts.add_argument("--disable-gpu")           # 无桌面环境
opts.add_argument("--disable-dbus")          # 关掉 dbus
opts.add_argument("--disable-features=VizDisplayCompositor")
opts.add_argument("--remote-debugging-port=0")  # 随机端口，避免冲突

# 如果你想 100% 不用 X11，再加一行：
opts.add_argument("--disable-extensions")
opts.add_argument("--disable-web-security")

driver = webdriver.Chrome(service=Service(), options=opts)
driver.get("https://www.qq.com")
print("标题 →", driver.title)
driver.quit()
(test) ubuntu@static-python3-0:/tmp/test$ cat 22.py
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

opts = Options()
# 关键参数组合：无头 + 禁用 GPU + 禁用沙箱 + 禁用 dev-shm + 禁用 dbus
opts.add_argument("--headless=new")          # 109+ 推荐写法
opts.add_argument("--no-sandbox")            # 容器/无 root 必须
opts.add_argument("--disable-dev-shm-usage") # 避免 /dev/shm 太小
opts.add_argument("--disable-gpu")           # 无桌面环境
opts.add_argument("--disable-dbus")          # 关掉 dbus
opts.add_argument("--disable-features=VizDisplayCompositor")
opts.add_argument("--remote-debugging-port=0")  # 随机端口，避免冲突

# 如果你想 100% 不用 X11，再加一行：
opts.add_argument("--disable-extensions")
opts.add_argument("--disable-web-security")

driver = webdriver.Chrome(service=Service(), options=opts)
driver.get("https://www.qq.com")
print("标题 →", driver.title)
driver.quit()
