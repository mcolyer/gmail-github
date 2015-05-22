InboxSDK.load('1', 'sdk_gh-experiment_b2c055d57d').then (sdk) ->

  sdk.Conversations.registerThreadViewHandler (threadView) ->
    el = document.createElement("div")
    el.innerHTML = "Hello World"
    threadView.addSidebarContentPanel {
      el: el,
      title: "Hello World",
    }
