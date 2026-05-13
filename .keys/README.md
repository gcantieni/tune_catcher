# .keys/ — Local Credentials

This directory is **gitignored** and must be populated manually on each machine before running `make publish-*`.

---

## App Store Connect (iOS + macOS)

### 1. Create an API key

In App Store Connect → Users & Access → Integrations → Keys:

- Create a new key with "App Manager" or "Developer" role
- Download the `.p8` file (only available once)
- Note the **Key ID** (e.g. `ABC123DEF4`) and **Issuer ID** (UUID shown on the page)

### 2. Place the key file

```
cp ~/Downloads/AuthKey_KEYID.p8 .keys/asc_api_key.p8
```

### 3. Create `.keys/env.sh`

```sh
export ASC_KEY_ID="YN88B246YD"
export ASC_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

---

## Android (Google Play)

### 1. Create a service account

In Google Play Console → Setup → API access → Link to a Google Cloud project:

- Create a service account with "Release Manager" permissions
- Download the JSON key file

### 2. Place the key file

```
cp ~/Downloads/service-account.json .keys/google-play-service-account.json
```

### 3. Create a release keystore (first time only)

```sh
keytool -genkey -v \
  -keystore .keys/release.jks \
  -alias upload \
  -keyalg RSA -keysize 2048 \
  -validity 10000
```

### 4. Create `android/key.properties`

```properties
storeFile=../.keys/release.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

---

## Expected directory layout

```
.keys/
  README.md                          ← this file (tracked)
  env.sh                             ← ASC_KEY_ID + ASC_ISSUER_ID (gitignored)
  asc_api_key.p8                     ← App Store Connect private key (gitignored)
  google-play-service-account.json   ← Google Play service account (gitignored)
  release.jks                        ← Android release keystore (gitignored)
```
