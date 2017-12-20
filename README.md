# Role Name

Install hbase as a single node

# Requirements

None

# Role Variables

| variable | description | default |
|----------|-------------|---------|
| hbase\_user           | user name of the service | hbase |
| hbase\_group          | group name of the service | hbase |
| hbase\_log\_dir       | log dir | /var/log/hbase |
| hbase\_db\_dir        | database dir | "{{ \_\_hbase\_db\_dir }}" |
| hbase\_zookeeper\_dir | path to zoopkeeper dir | "{{ \_\_hbase\_zookeeper\_dir }}" |
| hbase\_conf\_dir      | path to config file dir | "{{ \_\_hbase\_conf\_dir }}" |
| hbase\_regionserver\_service | service name | "{{ \_\_hbase\_service }}" |
| hbase\_conf           | path to hbase\_site.xml | "{{ \_\_hbase\_conf }}" |
| hbase\_flags          | not used yet | "" |
| hbase\_site           | content of site.xml in a dict | "" |
| hbase\_env\_sh        | content of hbase\_env.sh | ". {{ hbase\_conf\_dir }}/hbase-env-dist.sh" |
| hbase\_regionservers  | a list of regionservers | [] |

# Dependencies

None

# Example Playbook
```yaml
    - hosts: all
      roles:
        - ansible-role-hbase
      vars:
        hbase_env_sh: |
          . {{ hbase_conf_dir }}/hbase-env-dist.sh
          export HBASE_OPTS="-XX:+UseConcMarkSweepGC"
          export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m"
          export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m"
          export HBASE_MANAGES_ZK=false
        hbase_regionservers:
          - 127.0.0.1
        hbase_site:
          config:
            -
              - name: hbase.rootdir
              - value: "file://{{ hbase_db_dir }}"
            -
              - name: hbase.zookeeper.property.dataDir
              - value: /var/db/zookeeper
            -
              - name: hbase.cluster.distributed
              - value: true
```

# License

BSD

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
