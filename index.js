import dgram from 'node:dgram'

function trans(msg) {
  console.log(`SRC: ${msg}`)

  // Very dumb translation, but hopefully serves _all_ our purposes.
  // Assumes input is correctly formatted as Datadog.
  const msgRe =
    /(?<metricName>[^:]+):/.source +
    /(?<value>[^|]+)[|]/.source +
    /(?<type>[^|]+)[|]?/.source +
    /(@(?<sampleRate>[^|]+)[|])?/.source +
    /(#(?<tags>.*))?/.source
  const msgMatchGroups = msg.match(msgRe).groups

  const { metricName, type, sampleRate } = msgMatchGroups
  let { value, tags } = msgMatchGroups
  value *= 1 // * 1 converts to integer or float
  tags = (tags || '').split(',')

  let ftags
  if (msgMatchGroups.tags) {
    ftags = tags
      .reduce((acc, tagTagValue) => {
        const tagTagValueRe = /(?<tag>[^:]+):(?<tagValue>.*)/
        const { tag, tagValue } = tagTagValue.match(tagTagValueRe).groups
        return `${acc}.${tag}.${tagValue}`
      }, '')
      .substring(1)
  }

  let transMsg = metricName
  if (ftags) {
    transMsg += `_${ftags}`
  }
  transMsg += `:${value}|${type}`
  if (sampleRate) {
    transMsg += `|@${sampleRate}`
  }
  console.log(`DST: ${transMsg}`)

  return transMsg
}

const udpServer = dgram.createSocket('udp4')
const udpClient = dgram.createSocket('udp4')
const srcPort = 8125
const dstPort = 8135

udpServer
  .on('message', (udp) => {
    const msgs = udp.toString().split('\n')
    msgs.forEach((msg) => {
      const transMsg = trans(msg)
      udpClient.send(transMsg, dstPort, 'localhost')
    })
  })
  .bind(srcPort)
console.log(`Relaying UDP ${srcPort} to ${dstPort}...`)
