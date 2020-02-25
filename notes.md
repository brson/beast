out/beastdb +pd-server --name="pd" --data-dir="beastdb/pd"  --client-urls="http://127.0.0.1:2379" --peer-urls="http://127.0.0.1:2380" --force-new-cluster

out/beastdb +tikv-server --pd-endpoints="127.0.0.1:2379"
