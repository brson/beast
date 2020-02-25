out/beastdb +pd-server --name="pd" --data-dir="beastdb-data/pd"  --client-urls="http://127.0.0.1:2379" --peer-urls="http://127.0.0.1:2380" --force-new-cluster

out/beastdb +tikv-server --data-dir="beastdb-data/tikv" --pd-endpoints="127.0.0.1:2379"

out/beastdb +tidb-server -store tikv -path="127.0.0.1:2379"
