Qt.include("dom-parser.js")

var model, defaultBackground, host, pagePath

function getNodeBackgroundFromStyle(node) {
    var style = node.getAttribute('style')
    if (!style) return ''
    return parseUrl(new RegExp(/(\/[a-zA-Z0-9]+)+\.[a-z]+/g).exec(style)[0])
}

function parseUrl(url) {
    if (url.indexOf('//') === 0) return 'https:' + url
    if (url.indexOf('/') === 0) return host + url
    return url
}

function s(a) {
    return a.trim()
        .replace(/&nbsp;/g, ' ') // non-break space, currently just replace with normal space
        .replace(/&amp;/g, '&')
        .replace(/&lt;/g, '<')
        .replace(/&quot;/g, '"')
        .replace(/&#039;/g, "'")
        .replace(/&#x27;/g, "'")
}

function appendPlayer(node, status) {
    var player = {
        avatar: parseUrl(node.getElementsByClassName('player_info__icon')[0].getAttribute('src')),
        username: s(node.getElementsByClassName('player_info__username')[0].textContent()),
        playing: s(node.getElementsByClassName('player_info__playing')[0].textContent()),
        level: s(node.getElementsByClassName('player_info__level')[0].textContent()),

        status: status || ''
    }

    var lastSeenNode = node.getElementsByClassName('player_info__last_seen')[0]
    player.lastSeen = lastSeenNode.textContent().trim()
    player.lastSeenBold = lastSeenNode.getElementsByTagName('strong').length > 0

    player.recentlyPlayed = [];
    node.getElementsByClassName('recently_played__game').forEach(function(gameNode) {
        var imgNode = gameNode.getElementsByTagName('img')[0]
        if (imgNode)
            player.recentlyPlayed.push({gameIcon: parseUrl(imgNode.getAttribute('src'))})
    })

    var backgroundNode = node.getElementsByClassName('player_background')[0]
    player.background = (backgroundNode ? getNodeBackgroundFromStyle(backgroundNode) : '') || defaultBackground

    model.append(player)
}


WorkerScript.onMessage = function(message) {
    model = message.model
    defaultBackground = message.defaultBackground
    host = message.host
    pagePath = message.pagePath

    var request = new XMLHttpRequest();

    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status >= 200 && request.status <= 300) {
                var dom = new Dom(request.response)

                var h2Tags = dom.getElementsByTagName('h2')

                WorkerScript.sendMessage(h2Tags[0].textContent().replace(/\D+/g, ''))

                model.clear()

                h2Tags[0].parentNode.getElementsByClassName('player_card').forEach(function(node) {
                    appendPlayer(node, 'online')
                })
                h2Tags[1].parentNode.getElementsByClassName('player_card').forEach(function(node) {
                    appendPlayer(node)
                })

                model.sync()
                WorkerScript.sendMessage('loaded')
            }
        }
    }

    request.open('GET', host + pagePath)
    request.send()
}
