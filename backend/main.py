import functions_framework
from google.cloud import firestore
import json

# Initialize Firestore Client
db = firestore.Client()

@functions_framework.http
def counter_handler(request):
    # 1. Handle CORS (Allow your website to call this API)
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)

    headers = {'Access-Control-Allow-Origin': '*'}

    try:
        # 2. Reference the document
        # Collection: 'counters', Document: 'visitor_count'
        doc_ref = db.collection('counters').document('visitor_count')

        # 3. Atomic Increment
        doc_ref.update({'count': firestore.Increment(1)})

        # 4. Get the updated value
        updated_doc = doc_ref.get()
        new_count = updated_doc.to_dict().get('count', 0)

        return (json.dumps({'count': new_count}), 200, headers)

    except Exception as e:
        print(f"Error: {e}")
        return (json.dumps({'error': str(e)}), 500, headers)

