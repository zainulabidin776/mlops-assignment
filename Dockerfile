FROM python:3.10-slim
WORKDIR /app
COPY app/requirements.txt .
RUN pip install -r requirements.txt
COPY app/ ./app/
COPY model/ ./model/
WORKDIR /app
EXPOSE 5000
CMD ["python", "app/app.py"]
