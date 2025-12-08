openapi: 3.0.0

info:
  title: Visitor Counter API
  description: API for Cloud Resume visitor counter.
  version: 1.0.0

paths:
  /counter:
    get:
      summary: Increment and return visitor count
      operationId: visitorCounter

      x-google-backend:
        address: ${function_url}
        protocol: h2
        path_translation: APPEND_PATH_TO_ADDRESS

      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                type: object

components:
  securitySchemes: {}













