FROM slpcat/python:3.10.11-bullseye

RUN apt-get install -y libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs libreadline8 gcc
RUN useradd -s /bin/bash -d /app chatglm \
    && mkdir -p /app/ \
    && chown -R chatglm:chatglm /app

USER chatglm

RUN \
    cd /app \
    && git clone https://github.com/THUDM/ChatGLM-6B \
    && cd ChatGLM-6B \
    && pip3 install gradio \
    && pip3 install -r requirements.txt \
    && git clone https://github.com/Akegarasu/ChatGLM-webui

WORKDIR /app/ChatGLM-6B/ChatGLM-webui
#CMD ["python3", "./web_demo.py"]
CMD ["python3", "webui.py", "--listen", "--port", "7860"]
