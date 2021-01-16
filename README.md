# Git Issue Tracker 


### Installation Prerequisites

- Docker
- WSO2 API Manager v3.2.0 local installation
- Apictl tool


### Run MI

- [Setup](https://developers.google.com/hangouts/chat/how-tos/webhooks) a Google Chat room and get a webhook link
- Replace the following GOOGLE_CHAT_WEB_HOOK with the url taken from above step. Execute this to run MI in docker.

    ```
    docker run -e google_chat_web_hook='GOOGLE_CHAT_WEB_HOOK' -e issue_count='50' -p 8290:8290 -it reddragon77/mi-eventhub:v1
    ```

### Run APIM

- Start API Manager v3.2.0 in localhost

- Add an env for apictl

    ```
    apictl add-env -e production --apim  https://localhost:9443
    ```

- Log into the Environment

    ```
    apictl login production
    ```
    
- Import the API (EventHubAPI-v1)

    ```
    apictl import-api -f EventHubAPI-v1/ -e production
    ```

- Log into Devportal, create an application, subscribe to the API and generate keys.

### Run Frontend APP

- Copy the client id and client secret from the application in the devportl.

- Replace the following client id and client secret and paste these values in the terminal.

```
export APIM_CLIENT_ID="CLIENT_ID"
export APIM_CLIENT_SECRET="CLIENT_SECRET"
export API_ENDPOINT="https://localhost:8243"
export TOKEN_ENDPOINT="https://localhost:8243/token"
```
- Start the frontend application

    ```
    cd frontend
    npm install
	node server.js
    ```

- Navigate to [https://localhost:8000/](https://localhost:8000/)