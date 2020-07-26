FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install python3-pip wget unzip git -y

WORKDIR /app

# fclone
RUN wget -qO- https://api.github.com/repos/mawaya/rclone/releases/latest \
  | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 \
  | wget --no-verbose -i-
RUN unzip -j fclone*.zip -d /usr/bin && chmod 0755 /usr/bin/fclone
RUN mkdir -p /root/.config/rclone

# icopy
LABEL version="0.2.0-beta.6"
ENV LANG=C.UTF-8
RUN git clone https://github.com/fxxkrlab/iCopy.git
RUN chmod +x iCopy/iCopy.py
RUN pip3 install -r iCopy/requirements.txt

# run
COPY shell.sh .
CMD ["sh", "shell.sh"]