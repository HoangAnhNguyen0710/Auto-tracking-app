FROM python:3.11

WORKDIR /app

# Cài đặt Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Thêm Poetry vào PATH
ENV PATH="/root/.local/bin:${PATH}"

# Sao chép và cài đặt phụ thuộc
COPY pyproject.toml poetry.lock* /app/
RUN poetry install --no-root

# Cài đặt Playwright
RUN poetry run playwright install

# Sao chép mã nguồn ứng dụng
COPY . /app/

# Mở cổng và chạy ứng dụng
EXPOSE 10000
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
