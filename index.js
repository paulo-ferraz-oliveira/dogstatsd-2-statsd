import dgram from 'node:dgram'
import bunyan from 'bunyan'

const log = bunyan.createLogger({ name: 'dogstatsd-2-statsd', level: 'trace' })
const server = dgram.createSocket('udp4')

function trans(msg) {
  log.trace(`server got: ${msg}`)

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

  log.trace(`transformed it as ${transMsg}`)

  return transMsg
}

server.on('message', (udp) => {
  const msgs = udp.toString().split('\n')
  msgs.forEach((msg) => {
    trans(msg)
  })
})

server.bind(8125)
