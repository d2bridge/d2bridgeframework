// +--------------------------------------------------------------------------+
//  D2Bridge Framework Content
//
//  Author: Talis Jonatas Gomes
//  Email: talisjonatas@me.com
//
//  This source code is provided 'as-is', without any express or implied
//  warranty. In no event will the author be held liable for any damages
//  arising from the use of this code.
//
//  However, it is granted that this code may be used for any purpose,
//  including commercial applications, but it may not be modified,
//  distributed, or sublicensed without express written authorization from
//  the author (Talis Jonatas Gomes). This includes creating derivative works
//  or distributing the source code through any means.
//
//  If you use this software in a product, an acknowledgment in the product
//  documentation would be appreciated but is not required.
//
//  God bless you
 //+--------------------------------------------------------------------------+


// No JQuery need
document.addEventListener("DOMContentLoaded", function() {
    var prismPages = document.querySelectorAll("prismpage");
    prismPages.forEach(function(currentElement) {
        var viewpage = currentElement.getAttribute("viewpage");

        if (typeof isD2BridgeContext !== 'undefined' && isD2BridgeContext === true) {
            currentElement.parentNode.removeChild(currentElement);
        } else {
            if (typeof viewpage !== 'undefined' && viewpage !== "") {
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        currentElement.insertAdjacentHTML('afterend', xhr.responseText);
                        currentElement.parentNode.removeChild(currentElement);
                    } else if (xhr.readyState === 4 && xhr.status !== 200) {
                        console.error("Error load page", xhr.status, xhr.statusText);
                    }
                };
                xhr.open("GET", viewpage, true);
                xhr.send();
            }
        }
    });
});

// JQuery need
// $(document).ready(function () {
//     $("prismpage").each(function () {
//         var $currentElement = $(this);
//         var viewpage = $currentElement.attr("viewpage");

//         if (typeof isD2BridgeContext !== 'undefined' && isD2BridgeContext === true) {
//             $currentElement.replaceWith("");
//         } else {
//             if (typeof viewpage !== 'undefined' && viewpage !== "") {
//                 $.ajax({
//                     url: viewpage,
//                     type: 'GET',
//                     dataType: 'html',
//                     success: function (data) {
//                         $currentElement.replaceWith(data);
//                     },
//                     error: function (xhr, status, error) {
//                         console.error("Error load page", status, error);
//                     }
//                 });    
//             }
//         }
//     });
// });
