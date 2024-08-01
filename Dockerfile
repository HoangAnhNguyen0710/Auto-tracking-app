# Sử dụng hình ảnh cơ sở Python
FROM python:3.11

# Cài đặt Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Thêm Poetry vào PATH
ENV PATH="/root/.local/bin:${PATH}"

# Cài đặt các phụ thuộc hệ thống cần thiết cho Playwright
RUN apt-get update && apt-get install -y \
libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libnspr4 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    libxshmfence1 \
    libxkbcommon0 \
    libwayland-client0 \
    libwayland-server0 \
    fonts-liberation \
    libappindicator3-1 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép và cài đặt các phụ thuộc
COPY pyproject.toml poetry.lock* /app/
RUN poetry install --no-root
RUN pip install --upgrade pip \
    && pip install \
        annotated-types==0.7.0 \
        anyio==4.4.0 \
        APScheduler==3.10.4 \
        attrs==23.2.0 \
        blinker==1.7.0 \
        build==1.2.1 \
        CacheControl==0.14.0 \
        certifi==2024.2.2 \
        cffi==1.16.0 \
        charset-normalizer==3.3.2 \
        cleo==2.1.0 \
        click==8.1.7 \
        colorhash==2.0.0 \
        configparser==6.0.1 \
        contourpy==1.2.0 \
        crashtest==0.4.1 \
        cycler==0.12.1 \
        distlib==0.3.8 \
        dnspython==2.6.1 \
        dulwich==0.21.7 \
        email_validator==2.2.0 \
        fastapi==0.111.1 \
        fastapi-cli==0.0.4 \
        fastjsonschema==2.20.0 \
        filelock==3.15.4 \
        Flask==3.0.2 \
        Flask-Cors==4.0.0 \
        Flask-MonitoringDashboard==3.3.0 \
        fonttools==4.50.0 \
        greenlet==3.0.3 \
        gunicorn==21.2.0 \
        h11==0.14.0 \
        httpcore==1.0.5 \
        httptools==0.6.1 \
        httpx==0.27.0 \
        idna==3.6 \
        imbalanced-learn==0.12.0 \
        imblearn==0.0 \
        importlib_metadata==8.2.0 \
        installer==0.7.0 \
        itsdangerous==2.1.2 \
        jaraco.classes==3.4.0 \
        Jinja2==3.1.3 \
        joblib==1.3.2 \
        keyring==24.3.1 \
        kiwisolver==1.4.5 \
        kneed==0.8.5 \
        markdown-it-py==3.0.0 \
        MarkupSafe==2.1.5 \
        matplotlib==3.8.3 \
        mdurl==0.1.2 \
        more-itertools==10.3.0 \
        msgpack==1.0.8 \
        numpy==1.26.4 \
        outcome==1.3.0.post0 \
        packaging==24.0 \
        pandas==2.2.1 \
        pexpect==4.9.0 \
        pillow==10.2.0 \
        pkginfo==1.11.1 \
        platformdirs==4.2.2 \
        playwright==1.45.1 \
        poetry==1.8.3 \
        poetry-core==1.9.0 \
        poetry-plugin-export==1.8.0 \
        psutil==5.9.8 \
        ptyprocess==0.7.0 \
        pycparser==2.22 \
        pydantic==2.8.2 \
        pydantic_core==2.20.1 \
        pyee==11.1.0 \
        Pygments==2.18.0 \
        pyparsing==3.1.2 \
        pyproject_hooks==1.1.0 \
        PySocks==1.7.1 \
        python-dateutil==2.9.0.post0 \
        python-dotenv==1.0.1 \
        python-multipart==0.0.9 \
        pytz==2024.1 \
        PyYAML==6.0.1 \
        rapidfuzz==3.9.4 \
        requests==2.31.0 \
        requests-toolbelt==1.0.0 \
        rich==13.7.1 \
        scikit-learn==1.4.1.post1 \
        scipy==1.12.0 \
        shellingham==1.5.4 \
        six==1.16.0 \
        sklearn-pandas==2.2.0 \
        sniffio==1.3.1 \
        sortedcontainers==2.4.0 \
        SQLAlchemy==2.0.29 \
        starlette==0.37.2 \
        threadpoolctl==3.4.0 \
        tomlkit==0.13.0 \
        trio==0.26.0 \
        trio-websocket==0.11.1 \
        trove-classifiers==2024.7.2 \
        typer==0.12.3 \
        typing_extensions==4.10.0 \
        tzdata==2024.1 \
        tzlocal==2.0.0 \
        urllib3==2.2.1 \
        uvicorn==0.30.3 \
        uvloop==0.19.0 \
        virtualenv==20.26.3 \
        watchfiles==0.22.0 \
        websocket-client==1.8.0 \
        websockets==12.0 \
        Werkzeug==3.0.1 \
        wsproto==1.2.0 \
        xattr==1.1.0 \
        xgboost==2.0.3 \
        zipp==3.19.2
# Sao chép mã nguồn ứng dụng vào container
COPY . /app/

# Cài đặt Playwright trong môi trường Poetry
RUN poetry run pip install playwright

# # Cài đặt Playwright
RUN playwright install

# Mở cổng 8000
EXPOSE 8000
# RUN uvicorn main:app --reload
# Lệnh để chạy ứng dụng
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
