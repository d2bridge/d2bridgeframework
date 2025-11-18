document.addEventListener("DOMContentLoaded", function() {
    var htmlString = `
        <div id="d2bridge-loader">
            <div class="d2bridge-loader-wrapp">
                <div class="d2bridge-loader-item">
                    <p class="d2bridge-loader-text">Aguarde</p>
                    <div class="d2bridge-loader-ball-box ball-1"></div>
                    <div class="d2bridge-loader-ball-box ball-2"></div>
                    <div class="d2bridge-loader-ball-box ball-3"></div>
                </div>
            </div>
        </div>
    `;

    var tempContainer = document.createElement("div");
    tempContainer.innerHTML = htmlString;

    document.head.appendChild(tempContainer);

    var cssString = `
        /*--------D2Bridge Loader----------*/
        #d2bridge-loader {
            display: none; 
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.1);
            z-index: 9999;
        }

        .d2bridge-loader-wrapp {
            display: flex;
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
            border: 2px groove;
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
});
