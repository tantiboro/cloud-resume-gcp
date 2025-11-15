import functions_framework
from google.cloud import firestore
import json

# Initialize once (better performance)
db = firestore.Client()


@functions_framework.http
def visitor_counter(request):
    # CORS headers
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type",
    }

    if request.method == "OPTIONS":
        return ("", 204, headers)

    try:
        doc_ref = db.collection("visits").document("counter")

        # Atomic increment avoids race conditions
        doc_ref.set({"count": firestore.Increment(1)}, merge=True)

        # Read updated count
        doc = doc_ref.get()
        count = doc.to_dict().get("count", 0)

        return (
            json.dumps({"visits": count}),
            200,
            {"Content-Type": "application/json", **headers},
        )

    except Exception as e:
        return (
            json.dumps({"error": str(e)}),
            500,
            {"Content-Type": "application/json", **headers},
        )

