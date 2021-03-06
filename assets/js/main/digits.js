import {Socket} from "phoenix"

export var Digits = {
  run: () => {
    let socket = new Socket("/socket", {params: {token: window.userToken}})
    socket.connect()
    let channel = socket.channel("mnist:stream", {})

    channel.join()
      .receive("ok", () => console.log("Joined mnist:stream"))
      .receive("error", () => console.log("Unable to join mnist:stream"))

    channel.on("digit", payload => fadeDigit(payload))

    channel.push("digits", {})
      .receive("digits", payload => cloud(payload.digits))

    let queue = []

    function newIndex(length) {
      if (queue.length > 5) { queue = queue.slice(-5) }

      let j = Math.floor(d3.randomUniform(0, length)())
      while (queue.includes(j)) {
        j = Math.floor(d3.randomUniform(0, length)())
      }
      queue.push(j)

      return j
    }

    function replaceDigit(payload) {
      let digitImages = d3.selectAll(".digit-image").nodes()

      let i = newIndex(digitImages.length)
      let digitImage = d3.select(digitImages[i])

      let url = `data:image/png;base64,${payload.image}`
      digitImage.attr("xlink:href", () => url)

      $(digitImage.node()).tooltip("hide")
        .attr("data-original-title", payload.classification)
        .tooltip("setContent")

      $(digitImage.node()).filter(":hover").tooltip("show")
    }

    function fadeDigit(payload) {
      let digitImages = d3.selectAll(".digit-image").nodes()

      let i = newIndex(digitImages.length)
      let digitImage = d3.select(digitImages[i])

      let fade = 120

      $(digitImage.node()).fadeOut(fade, () => {
          let url = `data:image/png;base64,${payload.image}`
          digitImage.attr("xlink:href", () => url)

          $(digitImage.node()).fadeIn(fade, () => {
            $(digitImage.node()).tooltip("hide")
              .attr("data-original-title", payload.classification)
              .tooltip("setContent")

            $(digitImage.node()).filter(":hover").tooltip("show")
          })
        })
    }

    function cloud(digits) {
      let
        width = 200,
        height = 200,
        imageWidth = 28,
        imageHeight = 28

      let svg = d3.select("#digitcloud")
        .attr("width", width)
        .attr("height", height)

      let group = svg.append("g")
        .attr("transform", `translate(${width/2},${height/2})`)

      let bodies = d3.forceSimulation(digits)
        .force("charge", d3.forceManyBody().strength(-10/digits.length))
        .force("collide", d3.forceCollide(14 * Math.sqrt(2)))
        .force("center", d3.forceCenter(-(imageWidth/2), -(imageHeight/2)))
        .on("tick", move)

      let images = group.selectAll(".digit")
        .data(digits).enter()
        .append("image")
        .attr("class", "digit-image")
        .attr("width", imageWidth)
        .attr("height", imageHeight)
        .attr("xlink:href", d => `data:image/png;base64,${d.image}`)
        .attr("data-toggle", "tooltip")
        .attr("data-placement", "left")
        .attr("title", d => d.classification)

        let template = [
          '<div class="digit tooltip" role="tooltip">',
          '<div class="tooltip-inner"></div>',
          '<div class="arrow"></div>',
          '</div>'
        ].join('')

      $(".digit-image").tooltip({template: template, animation: false})

      function move() {
        images.attr("x", d => d.x).attr("y", d => d.y)
      }
    }
  }
}
