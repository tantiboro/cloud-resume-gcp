import unittest
from unittest.mock import MagicMock, patch
import json
import main  # This imports your Cloud Function code


class TestCounter(unittest.TestCase):

    @patch("main.db")  # Mocks the Firestore client defined in main.py
    def test_counter_handler(self, mock_db):
        # 1. Setup Mock Data
        mock_doc_ref = MagicMock()
        mock_doc_snapshot = MagicMock()

        # Simulate Firestore returning a count of 10
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
        mock_doc_ref.update.assert_called_once()  # Verify we actually tried to increment


if __name__ == "__main__":
    unittest.main()
