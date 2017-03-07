
function browserPlatform()
    {
    'use strict';
    if (navigator.userAgent.indexOf('iPhone') !== -1 ||
        navigator.userAgent.indexOf('iPad')   !== -1 ||
        navigator.userAgent.indexOf('iPod')   !== -1)
        { return 'iOS'; }

    if (navigator.platform.indexOf('Android') !== -1 ||
        navigator.platform.indexOf('Linux')   !== -1)
        { return 'Android'; }

    if (navigator.platform.indexOf('Mac') !== -1)
        { return 'Mac'; }

    if (navigator.platform.indexOf('Win') !== -1)
        { return 'Mac'; }

    if (navigator.platform.indexOf('Linux') !== -1)
        { return 'Linux'; }

    return 'Unknown';
    }
var downloadStarted = false;
function startDownload()
    {
    'use strict';
    if (browserPlatform() === 'iOS')
        {
        if (downloadStarted)
            { downloadStarted = false; }
        else {
            downloadStarted = true;
            var message = "The app "+appName+" is downloading to your home screen.";
            setTimeout(function() {
                window.alert(message);
                document.location = "permission.html"
            }, 300);
            document.location = downloadLink;
            }
        }
    else
        {
        window.alert('Open this link on an iOS device to download the app.');
        }
    }
function updateMessageBox()
    {
    'use strict';
    setTimeout(function() { window.scrollTo(0, 1); }, 100);
    var message =
        '<b>iOS Required<br><br>Open this page on your iOS device<br>to install ' +
        appName + '.</b>';
    if (browserPlatform() === 'iOS') {
        message = '<b>Tap here to install<br>' +appName+ '<br>on your iOS device.</b>';
    }
    message += '<br><br>'+versionString;
    var messagebox = document.getElementById('message-box');
    messagebox.innerHTML = message;
    }
window.onload = updateMessageBox;
