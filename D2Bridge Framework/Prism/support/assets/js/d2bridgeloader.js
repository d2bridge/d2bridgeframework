function LockThreadClient()
{
    requestAnimationFrame(() => {
     if (d2bridgeloader) {
        hided2bridgeloader = false;
        let _d2bridge_loader = document.getElementById('d2bridge-loader');
        _d2bridge_loader.style.backgroundColor = "";
        $('#d2bridge-loader').show();

        setTimeout(() => {
           if (d2bridgeloader) {
              if (!hided2bridgeloader) {
                 let _d2bridge_loader = document.getElementById('d2bridge-loader');
                 _d2bridge_loader.style.backgroundColor = "rgba(255, 255, 255, 0.2)";
                 let _d2bridge_loader_wrapp = document.getElementById('d2bridge_loader_wrapp');
                 if (_d2bridge_loader_wrapp) {
                    _d2bridge_loader_wrapp.style.display = 'flex';
                 }
              }
           }
        }, waitd2bridgeloader);
     }
  });
}

function UnLockThreadClient()
{
  hided2bridgeloader = true;
  requestAnimationFrame(() => {
     if (d2bridgeloader) {
        $('#d2bridge-loader').hide();
        let _d2bridge_loader_wrapp = document.getElementById('d2bridge_loader_wrapp');
        if (_d2bridge_loader_wrapp) {
           _d2bridge_loader_wrapp.style.display = 'none';
        }
     }
  });
}

function IsThreadClientLocked() {
  let loader = document.getElementById('d2bridge-loader');
  if (!loader) return false;

  let isVisible = loader.offsetParent !== null || loader.style.display !== 'none';
  return isVisible && !hided2bridgeloader;
}


$(document).ready(function() {
    var htmlString = `
        <div id="d2bridge-loader" style="display: none;">
            <div class="d2bridge-loader-wrapp" id="d2bridge_loader_wrapp" style="display: none;">
                <div class="d2bridge-loader-item">
                    <p class="d2bridge-loader-text">{{_d!Loader,WaitText_}}</p>
                    <div class="d2bridge-loader-ball-box ball-1"></div>
                    <div class="d2bridge-loader-ball-box ball-2"></div>
                    <div class="d2bridge-loader-ball-box ball-3"></div>
                </div>
            </div>
        </div>
    `;

    var tempContainer = document.createElement("div");
    tempContainer.innerHTML = htmlString;

    document.body.appendChild(tempContainer);

    var cssString = `
        /*--------D2Bridge Loader----------*/
        #d2bridge-loader {
            display: block;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            /*background-color: rgba(255, 255, 255, 0.1);*/
            z-index: 9999;
        }

        .d2bridge-loader-wrapp {
            /*display: flex;*/
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: absolute;
            text-align: center;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 3em;
            border: 1px groove darkgray;
            border-radius: 10px;
            border-width: thin;
            box-shadow: 0px 0px 50px rgba(0, 0, 0, 0.35);
        }
        
        .d2bridge-loader-item .d2bridge-loader-ball-box:nth-last-child(1) {
            animation: loading_loader 0.6s 0.1s linear infinite;
        }
        .d2bridge-loader-item .d2bridge-loader-ball-box:nth-last-child(2) {
            animation: loading_loader 0.6s 0.2s linear infinite;
        }
        .d2bridge-loader-item .d2bridge-loader-ball-box:nth-last-child(3) {
            animation: loading_loader 0.6s 0.3s linear infinite;
        }
        
        .d2bridge-loader-text {
            font-size: 1.2em;
        }
        
        .d2bridge-loader-ball-box {
            display: inline-block;
            width: 15px;
            height: 15px;
            border-radius: 15px;
        }  
        
        .d2bridge-loader-ball-box.ball-1 {
            background-color: #FA5667;
        }  
        
        .d2bridge-loader-ball-box.ball-2 {
            background-color: #7A45E5;
        }  
        
        .d2bridge-loader-ball-box.ball-3 {
            background-color: #FAC24C;
        }  
        
        @keyframes loading_loader {
            0 {
                transform: translate(0, 0);
            }
            50% {
                transform: translate(0, 15px);
            }
            100% {
                transform: translate(0, 0);
            }
        }
    `;

    var styleSheet = document.createElement('style');
    styleSheet.type = 'text/css';
    styleSheet.innerText = cssString;

    document.head.appendChild(styleSheet);

    LockThreadClient();
});
