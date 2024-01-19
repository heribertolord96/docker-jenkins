FROM jenkins/jenkins

USER root
# Install dependencies
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y git python3-pip python3-venv wget unzip curl

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -f -y && \
    rm google-chrome-stable_current_amd64.deb

# Download and unzip Chromedriver
ADD https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.71/linux64/chromedriver-linux64.zip /opt/chromedriver-linux64.zip
RUN unzip /opt/chromedriver-linux64.zip -d /opt/ && \
    mv /opt/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /opt/chromedriver-linux64.zip

# Install Node.js and Angular CLI
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g @angular/cli@latest

# Set up Python virtual environment and install Selenium
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install selenium==4.1.0

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get clean

USER jenkins