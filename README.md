# tf-aws-web-notes

## Build the package before step #03

cd 02/external/web

```bash
npm cache clean --force
```

```bash
rm -rf node_modules
rm package-lock.json
```

```bash
npm install
```

```bash
npm run test+build
```

optional

  ```bash
  npm audit fix --force
  ```
