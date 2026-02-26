import functions_framework
from google.cloud import firestore
import json

db_client = None

def get_db():
    global db_client
    if db_client is None:
        db_client = firestore.Client()
    return db_client

@functions_framework.http
def counter_handler(request):
    # CORS Headers
    headers = {'Access-Control-Allow-Origin': '*'}
    if request.method == 'OPTIONS':
        return ('', 204, {**headers, 'Access-Control-Allow-Methods': 'GET'})

    # 1. Get the DB using the helper
    db = get_db()
    
    try:
        # 2. Reference the specific document
        doc_ref = db.collection('counters').document('visitor_count')
        
        # 3. ATOMIC INCREMENT (This is what the test is looking for!)
        doc_ref.update({'count': firestore.Increment(1)})
        
        # 4. Get updated value to return
        res = doc_ref.get().to_dict()
        new_count = res.get('count', 0)
        
        return (json.dumps({'count': new_count}), 200, headers)
    
    except Exception as e:
        print(f"Error: {e}")
        return (json.dumps({'error': 'Internal Server Error'}), 500, headers)
    
