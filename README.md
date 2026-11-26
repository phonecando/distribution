# PhoneCanDo releases

This is the loading dock. Every PhoneCanDo build leaves from here: the APKs,
the `latest.json` the app checks for updates, the GPL sources we owe, and the
workflow that builds and ships them, out in the open on GitHub's runners.

PhoneCanDo runs AI agents on your Android phone and lets them use the phone
itself. The app is closed source; the part that touches your phone is open,
in [phonecando/phone-control](https://github.com/phonecando/phone-control).

## Get it

The easy way: [phonecando.app](https://phonecando.app), which hands you the
right file and its SHA-256.

Or pick it up here from [the latest release](https://github.com/phonecando/distribution/releases/latest).
Each release carries:

| File | What it is |
| --- | --- |
| `phonecando-<version>-lite-arm64.apk` | The starter: the app without phone control. Install this on your phone. |
| `phonecando-<version>-full-arm64.apk` | The full build with phone control. The starter offers it as its update. |
| `latest.json` | What the app reads to find an update. |
| `phonecando-<version>-binaries.SHA256SUMS` | The SHA-256 of every prebuilt binary the APKs carry. |
| `phonecando-<version>-phone-control.txt` | The phone-control commit the APKs were built with. |
| `phonecando-gcc-*-source.tar.gz`, `phonecando-linux-default-*-sources-*` | The complete source of the GPL and LGPL parts the APKs ship. |

Android 12 or newer, arm64.

## Check what you downloaded

Every published release is built, signed and attested by this repo's
workflow, [`.github/workflows/release.yml`](.github/workflows/release.yml).
With the [GitHub CLI](https://cli.github.com):

```sh
gh attestation verify phonecando-<version>-full-arm64.apk --repo phonecando/distribution
```

A pass means this exact file came out of a run of that workflow here, and not
from anywhere else. The run builds from a phone-control commit on its `main`,
which the attested `phonecando-<version>-phone-control.txt` names, so you can
read the very code that touches your phone. What a pass can't show: the rest
of the app's source is private, so you can't rebuild the APK yourself.

## How a release is built

`release.yml` checks the private app out at the commit asked for, puts
phone-control in it at the commit the app pins (and stops unless that commit
is on phone-control's `main`), runs every check the app has, builds both
APKs, and only then, after one of us approves, signs, attests and publishes.
The workflow's steps are all here to read; what each step runs lives in the
app's code.

## Bugs, ideas and questions

Something wrong with a release itself (a download that's broken or missing,
a checksum or attestation that won't verify, the workflow failing)? Open an
issue here. Everything about the app (bugs, agent requests, ideas and
questions) goes to [phonecando/feedback](https://github.com/phonecando/feedback). Found a security hole? See
[`SECURITY.md`](SECURITY.md) and report it privately.

## Licence

The app and every release file built from it come under the PhoneCanDo End
User License Agreement, which the app shows you and asks you to accept (also
at [phonecando.app/license](https://phonecando.app/license/)). The
third-party sources keep their own licences. This repo's workflow files are
here for you to read, not to reuse. Details: [`LICENSE`](LICENSE).
