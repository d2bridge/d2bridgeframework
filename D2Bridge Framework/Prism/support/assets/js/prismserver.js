function PrismServerFunctions() {
    async function sendWhenConnected(eventObject) {
        if (prismws && prismws.readyState === WebSocket.OPEN) {
            prismws.send(JSON.stringify(eventObject));
            return;
        }

        await new Promise(resolve => {
            const interval = setInterval(() => {
                if (prismws && prismws.readyState === WebSocket.OPEN) {
                    clearInterval(interval);
                    resolve();
                }
            }, 1);
        });

        prismws.send(JSON.stringify(eventObject));
    }  

    this.sendMessageAndAwaitResponse = function (message) {
        return new Promise((resolve, reject) => {
            var prismwsresponse;

            if (window.location.protocol === "https:") {
                connectionInfo.protocol = "wss";
            }
            else
            {
                connectionInfo.protocol = "ws";
            }

            if (connectionInfo.pathPrefix !== "/") {
                prismwsresponse = new WebSocket(connectionInfo.protocol + '://' + connectionInfo.host + ':' + connectionInfo.port + '/websocket' + connectionInfo.pathPrefix + '/connectionresponseparams?token=' + connectionInfo.token + '&prismsession=' + connectionInfo.prismsession + '&channelname=' + connectionInfo.channelname + '&viewportinfo=' + encodeURIComponent(D2BridgeGetViewportInfo()));
            } else {
                prismwsresponse = new WebSocket(connectionInfo.protocol + '://' + connectionInfo.host + ':' + connectionInfo.port + '/websocket' + '/connectionresponseparams?token=' + connectionInfo.token + '&prismsession=' + connectionInfo.prismsession + '&channelname=' + connectionInfo.channelname + '&viewportinfo=' + encodeURIComponent(D2BridgeGetViewportInfo()));
            }

            prismwsresponse.onopen = () => {
                prismwsresponse.send(message);
            };

            prismwsresponse.onmessage = (event) => {
                const response = event.data;
                resolve(response);
                prismwsresponse.close();
            };

            prismwsresponse.onclose = (event) => {
                if (event.code !== 1000) {
                    reject(new Error(`Connection close with code  ${event.code}`));
                }
            };

            prismwsresponse.onerror = (error) => {
                reject(error);
            };
        });
    }


    this.ExecEvent = function (UUID, Token, FormUUID, ID, EventID, Parameters, LockClient) {
        
        UpdateActivityTime();

        if (Parameters === undefined) {
            Parameters = "&";
        }

        LockClient = Boolean(LockClient);

        var eventObject = {
            "type": "procedure",
            "name": "ExecEvent",
            "wait": false,
            "parameters": [
                { "UUID": UUID },
                { "Token": Token },
                { "FormUUID": FormUUID },
                { "ID": ID },
                { "EventID": EventID },
                { "Parameters": Parameters },
                { "LockClient": LockClient }
            ],
        }

        if (LockClient === true)
            LockThreadClient();

        sendWhenConnected(eventObject);
    }  

    this.GetFromEvent = async function (UUID, Token, FormUUID, ID, EventID, Parameters, LockClient) {

        if (Parameters === undefined) {
            Parameters = "&";
        }

        LockClient = Boolean(LockClient);

        var eventObject = {
            "type": "function",
            "name": "GetFromEvent",
            "wait": true,
            "parameters": [
                { "UUID": UUID },
                { "Token": Token },
                { "FormUUID": FormUUID },
                { "ID": ID },
                { "EventID": EventID },
                { "Parameters": Parameters },
                { "LockClient": LockClient }
            ],
        }

        if (LockClient === true)
            LockThreadClient();

        try {
            return await this.sendMessageAndAwaitResponse(JSON.stringify(eventObject))
                .then(function(response) {
                    return response;
                });
        } catch (error) {
            console.error(`Erro: ${error.message}`);
            return "{}";
        }
    }

    this.CallBack = function (UUID, Token, FormUUID, CallBackID, Parameters, LockClient) {

        if (Parameters === undefined) {
            Parameters = "&";
        }

        LockClient = Boolean(LockClient);

        var eventObject = {
            "type": "function",
            "name": "CallBack",
            "wait": false,
            "parameters": [
                { "UUID": UUID },
                { "Token": Token },
                { "FormUUID": FormUUID },
                { "CallBackID": CallBackID },
                { "Parameters": Parameters },
                { "LockClient": LockClient }
            ],
        }

        if (LockClient === true)
            LockThreadClient();

        sendWhenConnected(eventObject);
    }

    this.Heartbeat = function (UUID, Token, FormUUID) {

        const currentTime = Date.now();
        const idleTimeInMillis = currentTime - lastActivityTime;
        let vIdleInSeconds = Math.floor(idleTimeInMillis / 1000);

        var eventObject = {
            "type": "heartbeat",
            "name": "Heartbeat",
            "wait": false,
            "parameters": [
                { "UUID": UUID },
                { "Token": Token },
                { "FormUUID": FormUUID },
                { "IdleInSeconds": vIdleInSeconds },
                { "LockClient": false }
            ],
        }

        sendWhenConnected(eventObject);
    }
}