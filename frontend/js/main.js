/**
 * GCP Cloud Resume Challenge - Visitor Counter Script
 * Tantiboro Ouattara, Ph.D.
 */

// 1. Define the API endpoint (Points to your GCP Load Balancer/Cloud Function)
const API_URL = "https://tantiboro.com/api/counter";

async function getVisitCount() {
    const countElement = document.getElementById("counter");

    try {
        // 2. Call the API
        // Note: Using GET as per our Python backend configuration
        const response = await fetch(API_URL);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        // 3. Update the HTML
        // This matches the {'count': X} JSON structure from the Python script
        if (data && typeof data.count !== 'undefined') {
            countElement.innerText = data.count;
            countElement.classList.add('animate-pulse'); // Optional: brief visual feedback
            
            // Remove pulse after 1 second
            setTimeout(() => {
                countElement.classList.remove('animate-pulse');
            }, 1000);
        } else {
            countElement.innerText = "Error: Invalid Data";
        }

    } catch (error) {
        console.error("Cloud Resume API Error:", error);
        if (countElement) {
            countElement.innerText = "Unavailable";
            countElement.classList.add('text-red-500');
        }
    }
}

// 4. Run the function when the page loads
document.addEventListener('DOMContentLoaded', getVisitCount);