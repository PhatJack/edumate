# **FUNCTIONAL SPECIFICATION DOCUMENT (FSD)**

**Product Name:** Edumate – Pedagogical Assistant for Parents

**Version:** 1.0.0

**Last Updated:** February 27, 2026

---

## **1. PRODUCT OVERVIEW**

**Edumate** is an AI-powered application that acts as a “pedagogical expert” assisting parents in guiding their children’s learning.

Unlike typical homework-solving apps (which scan images and provide direct answers), Edumate analyzes problems, aligns with the teaching methods used in school, and provides parents with guiding questions and communication scripts to help children think independently and arrive at answers on their own.

---

## **2. TARGET USERS**

* **Parents of elementary and middle school students:** Individuals who want to support their children’s learning at home but struggle with teaching methods or are unfamiliar with the current curriculum.

---

## **3. UI/UX ARCHITECTURE**

The application is designed with a **3-column layout** on Desktop and an **Overlay layout** on Mobile, consisting of:

1. **Left Sidebar (Management):** Document list and user profile
2. **Main Chat Area (Interaction):** AI chat interface, exercise selector, and input field
3. **Right Sidebar (Workspace):** Exercise details, reference method, and similar exercise generation

**Design Style:** Professional, minimalistic, no emojis, using Indigo and Slate as primary color themes.

---

## **4. DETAILED FUNCTIONAL SPECIFICATIONS**

### **4.1. Student Profile Management (User Profile)**

* **Description:** Personalizes the AI experience based on student characteristics
* **Data Fields:**

  * Parent name, Email (linked account)
  * Student name, Grade
  * Learning characteristics (Textarea): Notes on strengths, weaknesses, and preferences (e.g., “Struggles with geometry, prefers real-life examples”)
* **Behavior:**

  * Editable via Modal
  * Data is injected into the AI context to adjust tone and teaching style

---

### **4.2. Document Management**

* **Add New Document:** Pop-up allowing input from 5 sources:

  1. Upload PDF (long documents)
  2. Capture via Camera
  3. Upload Image
  4. Google Drive
  5. Direct text input

* **Document List:**

  * Each document creates an independent conversation session
  * Displays icons based on format (PDF, Image, Text)
  * Additional actions:

    * View original content (Eye icon)
    * Delete document (Trash icon)

---

### **4.3. Exercise Extraction & Analysis**

* **For short documents (Image, Text):**

  * Automatically analyzes and returns exercise list instantly

* **For long documents (PDF):**

  * Chat input is locked
  * User must input a **page number**
  * System scans and returns exercises from that page only

* **Focus Mode:**

  * User **must select a specific exercise** before chatting with AI
  * Chat input is disabled (dimmed) until selection is made

---

### **4.4. AI Interaction (Chatbot Interface)**

* **UI:**

  * Parent messages: Right side, Indigo background
  * AI messages: Left side, White background, Markdown supported

* **Smart Interaction:**

  * After scanning, AI provides clickable chips representing exercises for quick selection

* **Pedagogical Flow:**

  * AI does NOT give direct answers
  * Instead, it provides guiding questions

    * Example: “Ask your child: What information does the problem provide?”

---

### **4.5. Workspace (Right Sidebar)**

Activated when an exercise is selected (Focus Mode), including 3 core features:

#### **4.5.1. Exercise Detail & OCR Editing**

* Displays extracted problem text
* Allows **Edit Mode** for correcting OCR errors
* “Save” updates the system

---

#### **4.5.2. Teacher’s Solution (Reference Method)**

* **Purpose:** Align AI with actual classroom teaching methods
* Parents can:

  * Input summarized solution steps (text)
  * Upload images (camera, upload, Drive)
* “Save” confirms the teaching method for AI usage

---

#### **4.5.3. Generate Similar Exercises**

* **Purpose:** Create additional practice exercises
* Custom input field (e.g., “Use supermarket context”, “Numbers less than 10”)
* Generated exercise is:

  * Added to current document’s exercise list
  * Automatically set as the new Focus

---

### **4.6. Interactive Tour Guide**

The system integrates a Tour Guide (driver.js) with advanced mechanisms:

* **Auto-start:**

  * Runs automatically on first app launch
  * Stores flag `edumate_tour_completed` in LocalStorage

* **Mock Document:**

  * A temporary document (`isTourDoc`) used only for the tour
  * Prevents interference with real user data
  * Deleted after tour completion

* **Dynamic DOM Synchronization:**

  * Uses `requestAnimationFrame` instead of fixed timeouts
  * Ensures UI elements are fully visible before highlighting

---

## **5. MAIN USER FLOWS**

### **Flow 1: Using a PDF Document (Multi-page)**

1. Click **[+] Add Document** → Select PDF
2. AI detects long document and requests page selection
3. Parent inputs page number → Click “Scan”
4. AI returns exercise list from that page
5. Parent selects an exercise → Chat unlocks + Right Sidebar opens
6. Parent interacts with AI for guided teaching

---

### **Flow 2: Applying Teacher’s Method**

1. Exercise is selected (Focus Mode active)
2. Open Right Sidebar → Scroll to “Teacher’s Solution”
3. Input or upload solution method
4. Click “Save”
5. Chat with AI:

   * “Guide me to teach this problem”
   * AI responds based on provided method

---

## **6. NON-FUNCTIONAL REQUIREMENTS**

* **Responsive:**

  * Fully functional on Mobile, Tablet, Desktop
  * Sidebars become **slide-in overlays** on Mobile

* **Performance:**

  * Use `useMemo` to optimize filtering of active documents/exercises
  * Prevent unnecessary re-renders

* **Auto-scroll:**

  * Chat should automatically scroll to the latest message after each interaction
