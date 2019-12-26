# The Beijing Beast

A zero-installation, single-binary, do-everything database.

A simple way to test [TiDB][l].

A drop-in replacement for [MySQL][l].

A database that scales from a single node, to [huge workloads][l] across [hundreds of nodes][l].

**Note: This project is not implemented yet. It does nothing.**


- [What is it and why?][l]
- [Installation][l]
- [Use cases][l]
- [Configuration][l]
- [Future work][l]
- [Building from source][l]
- [Contributing][l]
- [License][l]


## What is it and why?!

Beast is a single binary (or library) that contains

- [TiDB][l], a MySQL-compatible query engine,
- [TiKV][l], the key/value storage engine that underlies TiDB,
- [Placement Driver][l], the coordinator between TiKV and its query engines.

It essentially runs an entire distributed database cluster in a single process.

[TiDB][l] is a badass distributed database, but it is difficult to set up and
run &mdash; its production configuration typically consists of many nodes. As
such, it has a limited audience of developers with big data needs, and who are
motivated to work through the setup process of a distributed database.

Beast puts all the components of TiDB into a single executable, making it
trivial to apply TiDB to single-node MySQL workloads, whether for evaluation,
development or production.


## Installation

Download the latest binary. The easiest way is to run this command:

```
curl -O https://TODO
```

Run the binary:

```
./beast-db

[beast] The Beijing Beast, version 0.1.0
[beast] components: TiDB, TiKV, PD
[beast] initializing database in ./beast-db
[beast] ** The Beijing Beast is listening **
[beast] ... for TiKV connections on port TODO
[beast] ... for PD connections on port TODO
[beast] ... for MySQL connections on port TODO
[beast] ... for Spark connections on port TODO
[beast] visit the dashboard at `http://localhost:4000`
[beast] run `mysql todo` to connect to TiDB
```

At this point you can use the standard [MySQL client][l] to interact with the database.


## Use cases

TODO


## Configuration

TODO


## Future work

- Release builds
- Include Grafana
- Include TiSpark
- Include TiFlash
- Include mysql client
- MySQL server frontend emulation
- Multiple frontends
- Autogeneration of frontend symlinks
- In-process embedding ala SQLite


## Building from source

TODO


## Contributing

TODO


## License

Apache-2.0 / MIT / BSL-1.0 / CC0-1.0

The code in this repository is distributed under any or all of the above
licenses, at your option. Any contributions to this repository are contributed
under all of the above licenses. Depencies on are distributed under their own
terms.


[l]: todo