from fastapi import FastAPI
from sqlalchemy.orm import Session
from database import SessionLocal, engine, Base
# import time
from playwright.sync_api import sync_playwright

app = FastAPI()

tracking_numbers = [
    "9200190349451101811081", "9200190349451101811203", "9200190349451101811012", "9200190349451101811142",
    "9200190349451101811036", "9200190349451101811135", "9200190349451101811005", "9200190349451101811104",
    "9200190349451101811074", "9200190349451101811197", "9200190349451101811128", "9200190349451101811043",
    "9234690349451102709044", "9200190349451101810848", "9205590349451101065869", "9200190349451101810886",
    "9200190349451101810855", "9234690349451102709020", "9234690349451102709037", "9200190349451101810831",
    "9200190349451101810879", "9200190349451101812354", "9200190349451101811630", "9200190349451101811883",
    "9200190349451101812248", "9200190349451101812101", "9200190349451101811692", "9200190349451101812200",
    "9200190349451101811784", "9200190349451101812224", "9200190349451101811951", "9200190349451101811494",
    "9200190349451101811753", "9200190349451101811845", "9200190349451101811678", "9200190349451101811982",
    "9234690349451102709174", "9200190349451101811821", "9200190349451101812262", "9200190349451101812491",
    "9200190349451101813214", "9200190349451101812767", "9200190349451101813047", "9200190349451101813221",
    "9200190349451101812866", "9200190349451101812750", "9200190349451101812637", "9200190349451101813016",
    "9200190349451101813207", "9200190349451101812699", "9200190349451101813139", "9200190349451101813184",
    "9200190349451101813153", "9200190349451101812781", "9200190349451101813320", "9200190349451101812651",
    "9200190349451101813030", "9200190349451101813023", "9200190349451101812590", "9200190349451101812606",
    "9200190349451101812958", "9200190349451101813269", "9200190349451101812484"
]

# Hàm chia danh sách thành các nhóm nhỏ hơn
def chunk_list(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

# Chuyển đổi danh sách thành chuỗi với mỗi mã trên một dòng
tracking_numbers_str = "\n".join(tracking_numbers)

# # Hàm để gửi các mã tracking
def send_tracking_codes():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        page = browser.new_page()
        page.goto('https://www.17track.net/en')
        print("Please complete the CAPTCHA in the browser window...")
        page.pause()  # Tạm dừng cho đến khi người dùng nhấn Resume trong DevTools

        # Sau khi người dùng hoàn tất CAPTCHA, thực hiện các thao tác tiếp theo
        # Ví dụ: Lấy nội dung HTML của trang
        # html_content = page.content()
        # print(html_content)
        # page.wait_for_load_state('networkidle')
        # # Tìm kiếm và tương tác với các yếu tố trên trang
        # content = page.content()
        # with open('page_content.html', 'w', encoding='utf-8') as file:
        #     file.write(content)  
        for chunk in chunk_list(tracking_numbers, 20):
            # Chuyển đổi nhóm mã theo dõi thành chuỗi
            tracking_numbers_str = "\n".join(chunk)
            search_box = page.query_selector("textarea[id='auto-size-textarea']") 
            search_box.fill(tracking_numbers_str)
            search_btn = page.query_selector('div[title="Click \'TRACK\' to retrieve tracking information for your shipment."]')
            search_btn.click()
            page.wait_for_timeout(5000)
            checkcapcha = page.query_selector('button[data-yq-events="submitCode"]')
            print(checkcapcha)
            page.wait_for_timeout(3000)
            if checkcapcha:
               page.pause()
        # page.wait_for_selector('button')
        # Chờ kết quả và trích xuất dữ liệu
        # page.wait_for_selector('button') 
            button = page.query_selector('button[data-original-title="Copy tracking results summary and paste into an Excel for use."]')
            clipboard_text = button.get_attribute('data-clipboard-text')
            print(f"Clipboard text: {clipboard_text}")
            page.goto('https://www.17track.net/en')
        browser.close()
    return 1


@app.get("/tracking")
def tracking():
    send_tracking_codes()
    return "done"

