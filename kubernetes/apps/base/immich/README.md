
### Installation

[Immich](https://github.com/immich-app/immich) requires existing Postgres and Redis instances running in the cluster prior to installation, and then specified in the Immich's [values.yaml](https://github.com/immich-app/immich-charts/blob/main/charts/immich/values.yaml) for Helm.

For Postgres I'm using the [CloudNativePG operator](https://github.com/cloudnative-pg/cloudnative-pg) (ref [video](https://www.youtube.com/watch?v=g59ki9z2SO8)). The Postgres subchart in the Immich's `values.yaml` is getting deprecated, so I ended up using something similar to [this one](https://github.com/immich-app/immich-charts/issues/149#issuecomment-2555588331). The password for the `immich`'s postgres user is stored in AWS SSM and retrieved using the [External Secrets operator](https://github.com/external-secrets/external-secrets).

To test that the postgres database was successfully created and the `immich` user was assigned the password from SSM:
```
# in a shell in a postgres pod
psql -U immich -h localhost
```

For `Redis` I'm simply using the standalone option created during Immich's installation itself. Another option is create a Deployment and a Service for Redis like [this](https://medium.com/@harshaljethwa19/redis-deploying-redis-on-kubernetes-building-chat-applications-with-redis-pub-sub-on-kubernetes-f81a56ec0273) and then add the Kubernetes Service's DNS to the Redis' `values.yaml` file.

For the Library I use an NFS share as PVC.

Then deploy using Helm as per [these instructions](https://github.com/immich-app/immich-charts/blob/main/README.md).
