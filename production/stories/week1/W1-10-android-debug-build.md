# W1-10 Android debug build for the owner's phone
> Lane: @gpt · Type: Config · Size: S · Depends on: — · Spec: milestone.md Week 1 exit

**Goal:** the owner can install the current build on their phone. There is no `export_presets.cfg` yet.

## Acceptance criteria
- [ ] An `Android` export preset (portrait, arm64, debug-signed, Mobile renderer). The keystore stays out of git, and its path is read from an env var or editor settings.
- [ ] `make apk` writes `build/android/runedeep-debug.apk`. `build/` is gitignored.
- [ ] `docs/android-build.md`: a 10-line guide for the owner (one-time SDK/keystore setup, `make apk`, `adb install -r`).

## Evidence
The `make apk` output pasted in the PR. The owner confirms that the app opens on their phone.

## Note
No Play Store, billing or signing-for-release work (milestone: out of scope).
