chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  fetch(request.url, credentials: "include").then (response) ->
    response.text().then (html) ->
      sendResponse({html: html})

  # Indicates that response will come asynchronously, so sendResponse works
  # inside of the callback above
  true
