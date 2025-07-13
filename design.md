# AI Chat App Development Plan (For Claude Code)

---

## ✅ Background and Purpose

* **Purpose of Development**:  
  Develop a web application that provides a chat feature using the OpenAI API (GPT-4o or higher) for a wide range of users.

* **Development Approach**:  
  Utilize AI-driven development with Claude and Gemini CLI. Minimize human intervention and let the AI handle code generation, improvement, and consistency management.

* **Development Environment**:  
  Development will be done on GitHub Codespaces and deployed via Fly.io. Local environments will not be used.

---

## ✅ Current Preparation Status

* GitHub repository: Created  
* GitHub Codespaces: Set up and running (Ubuntu-based)  
* Fly.io: Account, billing, CLI installation, and authentication complete  
* Claude Code: Will be used to generate UI code for the chat app  

---

## ✅ Initial Prototype

### 📌 Simple Chat Interface (Prototype)

* **Functional Requirements**:
  * Top area: Display conversation history with AI (text)
  * Bottom area: Text input field + send button
  * After sending: Get response from OpenAI API and display it
  * API key stored in `.env` as `OPENAI_API_KEY`

* **Tech Stack**:
  * HTML / CSS / JavaScript or Next.js (leave choice to AI)
  * Node.js-based backend to handle API requests
  * Dockerfile for deployment to Fly.io
  * `fly.toml` for Fly.io config
  * `.env.example` included to maintain secure key handling

---

## ✅ Planned Features (Future Prototype Enhancements)

1. Store chat history in DB (Supabase planned)
2. User authentication (postponed)
3. Maintain conversation consistency (e.g., vector search using MCPify.ai)
4. Payment integration (make OpenAI API paid via Stripe, separate process)

---

## ✅ Instructions to Claude

Please generate the following code based on this design document:

* Minimal HTML/CSS/JS or Next.js-based chat UI
* Code to interact with OpenAI API (.env integration)
* `Dockerfile` and `fly.toml` for Fly.io deployment
* Developer-friendly folder structure for GitHub Codespaces
* A `README.md` file with basic setup instructions

---

## ✅ Constraints and Notes

* Do NOT include secret keys like `.env` in the code
* It’s okay if Claude doesn’t know what MCPify.ai is
* Development must assume a Linux (Codespaces) environment; avoid Windows-specific code

---

## ✅ Expectations from Claude

* Generate clean and extensible code with awareness of overall architecture
* Include comments and sectioning to make future consistency easier via Gemini CLI

