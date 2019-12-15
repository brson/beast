# The Beijing Beast

A zero-installation, single-binary, do-everything database.

A simple way to test [TiDB][l].

A drop-in replacement for MySQL.

A database that scales from a single node to [huge workloads][l] across [hundreds of nodes][l].

- [Installation][l]
- [What is it?!][l]
- [Why?][l]
- [Use cases][l]
- [Configuration][l]
- [Future work][l]
- [Contributing][l]
- [License][l]


## What is it?!

Beast is a single binary that contains

- [TiDB][l], a MySQL-compatible query engine,
- [TiKV][l], the key/value storage engine that underlies TiDB,
- [Placement Driver][l], the coordinator between TiKV and its query engines.

It effectively runs an entire distributed database cluster in a single process.


## Why?

[TiDB][l] is a badass distributed database, but it is hard to set up and run
&mdash; its production configuration typically consists of many nodes. As such,
it has a limited audience of developers with more data than can fit on a single
machine, and who are motivated to work through the setup process of a
distributed database.

Beast puts all the components of TiDB into a single executable, making it trivial
to apply TiDB to single-node MySQL workloads, whether for development or
production.


## Installation

Download the latest binary. The easiest way is to run this command:

```
curl -O https://todo
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


[l]: todo