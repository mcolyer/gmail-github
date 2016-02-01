InboxSDK.load('1.0', 'sdk_gh-experiment_b2c055d57d').then (sdk) ->
  listUnsubscribeRe = /List-Unsubscribe: <(.*)>,\s*<(https:\/\/github.com\/notifications\/unsubscribe\/[\w\-]+)>/m
  successUnwatchedRe = /You’ve been unsubscribed from the thread/
  messageId = null

  sdk.Conversations.registerThreadViewHandler (threadView) ->
    messageId = null
    messageViews = threadView.getMessageViews()
    return if messageViews.length == 0

    messageView = messageViews[0]
    messageId = messageView.getMessageID()

  handle = sdk.Keyboard.createShortcutHandle(chord: "ctrl+e", description: "Unwatch this GitHub thread")
  sdk.Toolbars.registerToolbarButtonForThreadView
    title: "Unwatch"
    section: sdk.Toolbars.SectionNames.METADATA_STATE
    iconUrl: chrome.extension.getURL('images/archive.png')
    keyboardShortcutHandle: handle
    onClick: (e) ->
      if messageId
        gmailUserId = document.getElementsByTagName("head")[0].getAttribute("data-inboxsdk-ik-value")
        url = "?ui=2&ik=#{gmailUserId}&view=om&th=#{messageId}"
        saving = sdk.ButterBar.showSaving()
        fetch(url, credentials: "include").then (response) ->
          response.text().then (text) ->
            if matches = listUnsubscribeRe.exec(text)
              chrome.runtime.sendMessage {url: matches[2]}, (response) ->
                if matches = successUnwatchedRe.exec(response.html)
                  saving.resolve()
                else
                  saving.reject()
                  sdk.ButterBar.showError(text: 'Something went wrong', time: 1000)
            else
              saving.reject()
              sdk.ButterBar.showError(text: 'Not a GitHub thread', time: 1000)
