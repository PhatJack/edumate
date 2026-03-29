# EduMate Frontend API Catalog

This file is the frontend source of truth for API routing and wrapper mapping.

## Global Contract

- Base prefix: `/api/v1`
- Response envelope:
  - Success: `{ "success": true, "data": ... }`
  - Error: `{ "success": false, "error": { ... } }`
- Protected endpoints require `Authorization: Bearer <access_token>`.

## Endpoint Constants

- Constants are centralized in `lib/data/constants/api_endpoints.dart`.
- Domain wrappers are in `lib/data/repositories/`.

## Auth

- `POST /api/v1/auth/google` -> `AuthRepository.signInWithGoogle`
- `GET /api/v1/auth/me` -> `AuthRepository.getCurrentUser`

## Profile and Children

- `GET /api/v1/profile/me` -> `ProfileRepository.getMyProfile`
- `PATCH /api/v1/profile/me` -> `ProfileRepository.updateMyProfile`
- `GET /api/v1/profile/me/children` -> `ProfileRepository.listChildren`
- `POST /api/v1/profile/me/children` -> `ProfileRepository.createChild`
- `PATCH /api/v1/profile/me/children/{child_id}` -> `ProfileRepository.updateChild`
- `DELETE /api/v1/profile/me/children/{child_id}` -> `ProfileRepository.deleteChild`

## Documents and Exercises

- `GET /api/v1/documents` -> `DocumentsRepository.listDocuments`
  - Supports query `child_id`, `limit`, `offset`
- `POST /api/v1/documents` -> `DocumentsRepository.createDocument`
- `POST /api/v1/documents/import-drive` -> `DocumentsRepository.importDrive` (mock behavior on backend)
- `GET /api/v1/documents/{document_id}` -> `DocumentsRepository.getDocument`
- `PATCH /api/v1/documents/{document_id}` -> `DocumentsRepository.updateDocument`
- `DELETE /api/v1/documents/{document_id}` -> `DocumentsRepository.deleteDocument`
- `POST /api/v1/documents/{document_id}/upload` -> `DocumentsRepository.uploadDocumentFile`
- `POST /api/v1/documents/{document_id}/scan-page` -> `DocumentsRepository.scanPage` (mock OCR)
- `GET /api/v1/documents/{document_id}/exercises` -> `DocumentsRepository.listExercises`
- `PATCH /api/v1/documents/{document_id}/exercises/{exercise_id}` -> `DocumentsRepository.updateExercise`
- `POST /api/v1/documents/{document_id}/exercises/{exercise_id}/sample-solution-image` -> `DocumentsRepository.uploadExerciseSampleSolutionImage`
- `POST /api/v1/documents/{document_id}/exercises/{exercise_id}/similar` -> `DocumentsRepository.generateSimilarExercise` (mock generation)

## Chat

- `GET /api/v1/documents/{document_id}/messages` -> `ChatRepository.listMessages`
- `POST /api/v1/documents/{document_id}/chat` -> `ChatRepository.sendMessage`
  - `exercise_id` is mandatory
  - `message_type=welcome` may include `meta.exercise_ids`

## Uploads

- `POST /api/v1/uploads` -> `UploadsRepository.uploadGlobalFile`

## Users

- `GET /api/v1/users` -> `UsersRepository.listUsers`
- `GET /api/v1/users/{user_id}` -> `UsersRepository.getUserById`
- `PATCH /api/v1/users/{user_id}` -> `UsersRepository.updateUserById`

## Notes

- For paginated endpoints, wrappers map `items`, `total`, `limit`, `offset`, and `has_next`.
- Upload endpoints can return `backend: stub` when Firebase Storage is not configured.
- Backend source of truth remains API routers and schemas in `edumate-api/src`.
