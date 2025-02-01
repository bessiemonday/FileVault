# FileVault - Decentralized File Storage on Stacks

## Overview

FileVault is a smart contract built on the Stacks blockchain that enables decentralized file metadata storage. It allows users to store, retrieve, update, and delete file records while ensuring ownership verification and expiry-based access control.

## Features

- **File Management:** Add, retrieve, update, and delete file records.
- **Ownership Control:** Only file owners can modify or delete their entries.
- **Expiry Enforcement:** Prevents access to expired file records.
- **Error Handling:** Validates input data and enforces permission rules.

## Smart Contract Functions

- `add-file(location, expiry)`: Stores a file with an expiry date.
- `get-file(file-id)`: Retrieves a file's metadata if not expired.
- `update-file(file-id, new-location, new-expiry)`: Allows owners to update location and expiry.
- `delete-file(file-id)`: Enables owners to delete their files.

## Installation & Deployment

To deploy the contract, use [Clarinet](https://github.com/hirosystems/clarinet):

```sh
clarinet check
clarinet test
clarinet deploy
```
