verifyGithubWebhook = require('verify-github-webhook').default

verifySignature = (signature, payload, secret) ->
  payload = new Buffer(JSON.stringify(payload))
  return true unless secret?
  verifyGithubWebhook(signature, payload, secret)

module.exports = (robot) ->
  secret = process.env['GITHUB_WEBHOOK_SECRET']
  robot.on 'github-repo-event', (repoEvent) =>
    unless verifySignature(repoEvent.signature, repoEvent.payload, secret)
      throw new Error('Invalid Webhook Signature')

    robot.logger.info('received valid webhook, notifying consumers')
    robot.emit "github-verified-repo-event", repoEvent
