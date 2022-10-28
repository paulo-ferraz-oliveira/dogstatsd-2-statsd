# dogstatsd-2-statsd

We implement a very basic translation layer for when you're using
Datadog as a remote sink for your metrics but, e.g. locally you're using
Graphite.

## Reference

* Datadog: Datagram Format and Shell Usage:
  * <https://docs.datadoghq.com/developers/dogstatsd/datagram_shell?tab=metrics>

* Stats: StatsD Metric Types:
  * <https://github.com/statsd/statsd/blob/master/docs/metric_types.md>

## Usage

To use for the first time:

```shell
npm install
```

Make sure your 8125 is not bound and then:

```shell
node index.js | ./node_modules/bunyan/bin/bunyan
```

Now start sending your metrics and watch the logs.

## Linting

To lint

```shell
npm run lint
```

## Formatting

To format

```shell
npm run format
```
