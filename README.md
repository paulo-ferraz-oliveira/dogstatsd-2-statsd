# dogstatsd-2-statsd [![CI][ci-img]][ci] [![Lint][lint-img]][lint]

[ci-img]: https://github.com/paulo-ferraz-oliveira/dogstatsd-2-statsd/actions/workflows/ci.yml/badge.svg
[ci]: https://github.com/paulo-ferraz-oliveira/dogstatsd-2-statsd/actions/workflows/ci.yml
[lint-img]: https://github.com/paulo-ferraz-oliveira/dogstatsd-2-statsd/actions/workflows/lint.yml/badge.svg
[lint]: https://github.com/paulo-ferraz-oliveira/dogstatsd-2-statsd/actions/workflows/lint.yml

We implement a very basic translation layer for when you're using
Datadog as a remote sink for your metrics but, e.g. locally you're using
Graphite.

## References

* Datadog: Datagram Format and Shell Usage:
  * <https://docs.datadoghq.com/developers/dogstatsd/datagram_shell?tab=metrics>

* Stats: StatsD Metric Types:
  * <https://github.com/statsd/statsd/blob/master/docs/metric_types.md>

## Docker

Find a Docker container, created from our [Dockerfile](Dockerfile), at
[Docker Hub: pauloferrazoliveira/dogstatsd-2-statsd](https://hub.docker.com/repository/docker/pauloferrazoliveira/dogstatsd-2-statsd).

## Usage

To use for the first time:

```shell
npm install --omit=dev
```

Make sure your 8125 is not bound and then:

```shell
node index.js
```

Now start sending your metrics and watch the logs.

### Assumptions

* local port 8125 is not bound (this is our input)
* local port 8135 is bound to `statsd` input

## Contributing

First, make sure you have `yarn` installed locally.

Then run

```shell
npm install
```

to install dev dependencies.

Also, check [CONTRIBUTING](CONTRIBUTING.md).

## Linting

To lint

```shell
npm run eslint
```

## Formatting

To format

```shell
npm run prettier
```

## Versioning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Readme

We get inspiration for our README's format/content from
[Make a README](https://www.makeareadme.com/).

## Changelog

See the [Releases](../../releases) page.

## License

Check [LICENSE](LICENSE.md).
