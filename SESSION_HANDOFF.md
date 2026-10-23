# Installer backup repair

Base: `5ed194649a01c38cfac69b2d7bfbf1b9fb37f4c2` on `master`.
Branch: `fix/security-backups-october-2026`.

The `link()` helper reserves a unique private directory beside an existing destination before moving it. Previous backups are never reused or removed. The old item is retained at `<destination>.bak-<timestamp>.<random>/original`; files, directories and symlink objects use the same recovery path. A correct symlink remains a no-op, and an absent destination needs no backup.

Reservation output must be nonempty and match the expected same-parent path. The directory must exist, belong to the current user, have mode 700 and not be a symlink. Reservation, move, directory-creation and link failures return failure explicitly, including when the helper is called from a shell conditional.

If a move fails, the reservation can remain empty for diagnosis. If the move succeeds but a later step fails, the destination can be absent while the original remains under the reported `original` path. The helper reports that exact recovery path and does not overwrite an intervening destination or attempt destructive rollback. Before manual recovery, inspect the current destination and retained item; restore only after deciding what should occupy the destination. Keep other backups until their owner decides how to retain them.

## Verification

`bash -n` passes for the installer, focused test and extracted helper. Independent review approved the exact helper and harness before execution. The test extracts exactly one `link()` definition instead of sourcing the installer. It uses a fixed backup suffix, task-only synthetic HOME and failure overrides confined to case subshells. Fixtures and diagnostics are retained.

The baseline collision check fails as expected because the previous installer destroys a pre-existing same-name backup. All 21 candidate cases pass: old files and directories, broken/wrong/correct symlinks, absent paths, repeated suffixes, paths with spaces and reservation/move/mkdir/link failures in normal and conditional shell contexts. The audit workspace retains source/helper/test hashes, logs and task fixtures under `batch-2-results/ghostty-config-backup-verification`.

Run the focused check with a newly chosen task-only directory:

```sh
TEST_FIXTURE_PARENT=/absolute/task/fixture-parent bash --noprofile --norc tests/installer-backup.sh
```

The parent must exist. This runs only the extracted helper, retains its synthetic HOME, and does not apply configuration. Independent exact-diff review is required before commit.

## Limits

This is a local data-preservation repair. It does not make concurrent destination changes atomic or protect against a hostile process with the same user ID. The fixture does not certify every filesystem, mount, ACL, extended-attribute or interruption case.

No complete installer, user HOME configuration, Ghostty process, remote source, package acquisition or service operation has been run. Root owns publication after independent exact-diff review.
