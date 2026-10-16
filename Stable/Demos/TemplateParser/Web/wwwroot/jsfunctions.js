var sessionpushid = "";

function ShowCallBackInfo() {
  {{CallBack=CallBackTest1}}
}

function ShowCallBackInfoWithParam() {
  const vValue = "valuetest";

  {{CallBack=TestResponseWithValue2([vValue])}}
}



async function CallPingApi() {
  try {
    const baseUrl =
      window.location.protocol +
      '//' +
      window.location.hostname +
      (window.location.port ? ':' + window.location.port : '');

    const token = connectionInfo.token; 

    const url = baseUrl + '/api/ping?token=' + encodeURIComponent(token);

    const response = await fetch(url, {
      method: 'GET',
    });

    if (!response.ok) {
      throw new Error('Request failed: ' + response.status);
    }

    let vResponse = null;

    const json = await response.json(); 

    if (json && typeof json === 'object' && 'result' in json) {
      vResponse = json.result;
    }

    {{CallBack=StaticCBExample([vResponse])}}
  } catch (err) {
    console.error('Error calling /api/ping:', err);
  }
}

