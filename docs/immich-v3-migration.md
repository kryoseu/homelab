<!--toc:start-->
- [Immich v3 database migration](#immich-v3-database-migration)
  - [Overview](#overview)
  - [Steps](#steps)
<!--toc:end-->

### Immich v3 database migration

#### Overview

As described in [v3-migration](https://immich.app/blog/v3.0.0-release), Immich migrated away from `pgvecto.rs` in favor of its successor `VectorChord`. Immich provides its own `postgres` image with both extensions enabled to facilitate the migration. However, since I use `CloudNativePG` for Kubernetes, that was not an option. Below are the steps I took to migrate the database and upgrade to Immich v3.

The idea was: bootstrap a separate cluster (still using the `pgvecto.rs` image) from a prod backup, prep it, migrate it to the VectorChord image, and then upgrade Immich to point at the migrated database. After confirming it worked, just run the same steps against the prod database and point Immich to it.

#### Steps

1. Created a separate cnpg cluster to act as a dry-run.
2. Scaled down the `immich-server` deployment to `0`.
3. Once tmp cluster was up and healthy, I ran these:

```sql
DROP INDEX IF EXISTS clip_index;
DROP INDEX IF EXISTS face_index;

ALTER TABLE smart_search ALTER COLUMN embedding SET DATA TYPE real[];
ALTER TABLE face_search  ALTER COLUMN embedding SET DATA TYPE real[];
```

4. Updated the tmp cluster to use the image `ghcr.io/tensorchord/cloudnative-vectorchord:16.9-0.4.2` and deployed:

```yaml
imageName: ghcr.io/tensorchord/cloudnative-vectorchord:16.9-0.4.2
instances: 3

postgresql:
  shared_preload_libraries:
    - "vchord.so"
```

5. Once up and healthy, I ran these:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS vchord CASCADE;

ALTER TABLE smart_search ALTER COLUMN embedding SET DATA TYPE vector(512);
ALTER TABLE face_search  ALTER COLUMN embedding SET DATA TYPE vector(512);

DROP EXTENSION IF EXISTS vectors CASCADE;
DROP SCHEMA IF EXISTS vectors CASCADE;
```

6. Upgraded Immich image to `v3.0.0` and pointed to the new cluster service:

```yaml
containers:
  main:
    image:
      tag: v3.0.0
    env:
      DB_HOSTNAME: immich-postgres-migration-rw.home-apps.svc.cluster.local

```
