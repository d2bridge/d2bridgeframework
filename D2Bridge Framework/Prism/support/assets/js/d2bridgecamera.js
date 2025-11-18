let D2BridgeCameraAllowed = -1;
let D2BridgeCameraAllowedAudio = false;
let D2BridgeCurrentCameraId = "";
let D2BridgeCameralist = [];

async function D2BridgeCameraInitialize() {
  let navcompatibility = true;
  D2BridgeCameraAllowed = -1;
  D2BridgeCameraAllowedAudio = false;
  if (!navigator.permissions) {
      navcompatibility = false;
      D2BridgeCameraAllowed = 0;
  }
  if (navcompatibility) {
    try {
       await D2BridgeLoadCameraList();
       const checkcamera = await navigator.permissions.query({ name: "camera" });
       if (checkcamera.state === "granted") {
           D2BridgeCameraAllowed = 1;
       } else {
           D2BridgeCameraAllowed = 0;
       }
       const checkaudio = await navigator.permissions.query({ name: "microphone" });
       if (checkaudio.state === "granted") {
           D2BridgeCameraAllowedAudio = true;
       } else {
           D2BridgeCameraAllowedAudio = false;
       }
    } catch (e) {
    }

    OnCameraInitialize();
  }
}

async function D2BridgeLoadCameraList() {
  D2BridgeCameralist = [];
  D2BridgeCurrentCameraId = "";

  const isFirefox = navigator.userAgent.toLowerCase().includes("firefox");

  if (isFirefox) {
    const match = document.cookie.match(/(?:^|; )d2bridgecameralist=([^;]*)/);
    if (match && match[1]) {
      try {
        const stored = JSON.parse(decodeURIComponent(match[1]));
        if (Array.isArray(stored)) {
          D2BridgeCameralist = stored;
          if (stored.length > 0) {
            D2BridgeCurrentCameraId = stored[0].id;
          }
          return; 
        }
      } catch (e) {
      }
    }
  }

  const devices = await navigator.mediaDevices.enumerateDevices();
  const cameras = devices.filter(device => device.kind === "videoinput");

  cameras.forEach((cam, index) => {
    if (cam.deviceId !== "") {
      D2BridgeCameralist.push({ id: cam.deviceId, index: index, name: cam.label || `Camera ${index + 1}` });
    }
  });

  if (D2BridgeCameralist.length > 0 && D2BridgeCurrentCameraId === "") {
    D2BridgeCurrentCameraId = D2BridgeCameralist[0].id;
  }

  if (D2BridgeCameralist.length > 0)
    D2BridgeCameraAllowed = 1;
}


async function D2BridgeSaveCameraListToCookie() {
  const devices = await navigator.mediaDevices.enumerateDevices();
  const cameras = devices.filter(device => device.kind === "videoinput" && device.deviceId);

  const cameraList = cameras.map((cam, index) => ({
    id: cam.deviceId,
    index: index,
    name: cam.label || `Camera ${index + 1}`
  }));

  document.cookie = "d2bridgecameralist=" + encodeURIComponent(JSON.stringify(cameraList)) + "; path=/; max-age=2147483647; expires=Tue, 19 Jan 2038 03:14:07 GMT";
}

async function D2BridgeCameraPermission() {
  D2BridgeCameraAllowed = -1;
  D2BridgeCameraAllowedAudio = false;

  let tempStream = null;
  try {
    tempStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
    D2BridgeCameraAllowedAudio = true;
  } catch (e1) {
    try {
        tempStream = await navigator.mediaDevices.getUserMedia({ video: true });
    } catch (e2) {
        D2BridgeCameraAllowed = 0;
    }
  }
  if (tempStream) {
    try {
        tempStream.getTracks().forEach(track => track.stop());
    } catch (e) {
        D2BridgeCameraAllowed = 0;
    }
    D2BridgeCameraAllowed = 1;  
  }

  const isFirefox = navigator.userAgent.toLowerCase().includes("firefox");
  if (isFirefox)
    await D2BridgeSaveCameraListToCookie();
  await D2BridgeLoadCameraList();    
}

function D2BridgeCameraInfo() {
    return JSON.stringify({
        "items" : D2BridgeCameralist,
        "allowed" : D2BridgeCameraAllowed,
        "allowedaudio" : (D2BridgeCameraAllowedAudio === 1), 
        "id" : D2BridgeCurrentCameraId
    });
}

async function WaitForCameraPermission(timeoutMs = 30000) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    if (typeof D2BridgeCameraAllowed !== 'undefined' && D2BridgeCameraAllowed !== -1) {
      return true;
    }
    await new Promise(resolve => setTimeout(resolve, 100));
  }
  return false;
}

$(document).ready(async function() {    
    await D2BridgeCameraInitialize();    
});