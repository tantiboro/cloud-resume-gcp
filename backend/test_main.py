import unittest
from unittest.mock import MagicMock, patch
import json
import main

class TestCounter(unittest.TestCase):

    # Patch the helper function instead of the global variable
    @patch("main.get_db")  
    def test_counter_handler(self, mock_get_db):
        # 1. Setup Mock Data
        mock_db = MagicMock()
        mock_get_db.return_value = mock_db # Inject the mock client
        
        mock_doc_ref = MagicMock()
        mock_doc_snapshot = MagicMock()

        mock_doc_snapshot.to_dict.return_value = {"count": 10}
        mock_doc_ref.get.return_value = mock_doc_snapshot
        mock_db.collection.return_value.document.return_value = mock_doc_ref

        # 2. Simulate the HTTP Request
        mock_request = MagicMock()
        mock_request.method = "GET"

        # 3. Call the function
        response = main.counter_handler(mock_request)

        # 4. Parse response
        data = json.loads(response[0])
        status_code = response[1]

        # 5. Assertions
        self.assertEqual(status_code, 200)
        self.assertEqual(data["count"], 10)
        mock_doc_ref.update.assert_called_once()

if __name__ == "__main__":
    unittest.main()