# Product Overview

Smart Photo Archive is an Android application for reliable photo backup and protection.

## Product Goal

The product helps users identify which photos are protected, back up optimized copies to cloud storage, and avoid duplicate uploads.

## Release 1.0 Focus

Release 1.0 focuses on one reliable workflow:

1. Request access to the photo library.
2. Connect Google Drive.
3. Build a local index of photos.
4. Prepare optimized backup copies.
5. Upload protected copies to cloud storage.
6. Track backup state locally.
7. Show the user which photos are protected.

## MVP Boundaries

Release 1.0 does not include video backup, restore, search, AI classification, similar-photo detection, gallery cleanup, original deletion, or multiple cloud providers.

## Product Principles

- Local state must be trustworthy.
- Uploads must be idempotent.
- Background work must survive app restarts.
- The user must understand protection status without inspecting internal logs.
- Free/Premium restrictions must not compromise data safety.
