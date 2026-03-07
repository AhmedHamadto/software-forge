---
name: voice-agent-prompt
description: Engineer system prompts for LiveKit voice agents with multilingual support. Use when creating or optimizing AI agent conversation flows.
---


Create and optimize system prompts for LiveKit voice agents with multilingual support.

## When to Use
- Creating new agent personas or use cases
- Optimizing conversation flow
- Adding new languages
- Tuning agent behavior for specific scenarios

## Project Context

Before starting, locate the voice agent files in the current project:

```
find . -name "voice_agent.py" -o -name "prompts.py" -o -name "agent.py" | head -10
grep -rn "AgentSession\|VoicePipelineAgent\|LiveKit" --include="*.py" | head -10
```

## Typical Agent Architecture

```
Inbound Call → SIP Trunk → LiveKit Room → Agent Worker
                                           ↓
                         VAD → STT → LLM → TTS
                                           ↓
                                 Function Tools (domain actions)
```

Common stack combinations:
- **VAD:** Silero
- **STT:** Deepgram, Whisper, Google Speech
- **LLM:** GPT-4o-mini, Claude, Gemini
- **TTS:** Cartesia, ElevenLabs, Google TTS

## System Prompt Structure

```python
SYSTEM_PROMPTS = {
    "en": """You are a friendly and efficient AI assistant for {business_name}.

## Your Role
- Handle phone interactions naturally and accurately
- Answer questions about available services
- Collect required information
- Confirm details before submitting

## Conversation Guidelines
1. Greet warmly and ask how you can help
2. Listen carefully to the request
3. Repeat back details to confirm
4. Suggest relevant options when appropriate
5. Confirm the complete request before finalizing
6. Provide next steps or estimated wait time
7. Thank the caller

## Important Rules
- NEVER make up information — use the available tools
- ALWAYS confirm key details before proceeding
- If unsure about something, ask for clarification
- Keep responses concise (under 30 words when possible)
- Use natural conversational language, not robotic scripts

## Available Tools
- get_items(category?) - Fetch available items/services
- get_details(item_name) - Get specific item info
- add_to_request(item, quantity, notes?) - Add item to request
- remove_from_request(item) - Remove item
- get_summary() - Show current request
- submit_request(name, phone, type) - Finalize
- clear_request() - Start over

## Handling Edge Cases
- Unknown items: "I don't see that in our system. Would you like me to list the available options?"
- Unclear speech: "I didn't quite catch that. Could you repeat it?"
- Pricing questions: Always use get_details() for accurate info
""",

    "es": """Eres un asistente de IA amigable y eficiente para {business_name}.
...
""",
    # Additional languages...
}
```

## Greeting Templates

```python
GREETINGS = {
    "en": "Hello! Thank you for calling {business_name}. How can I help you today?",
    "es": "¡Hola! Gracias por llamar a {business_name}. ¿Cómo puedo ayudarle hoy?",
    "fr": "Bonjour! Merci d'appeler {business_name}. Comment puis-je vous aider?",
    "ar": "مرحباً! شكراً لاتصالك بـ {business_name}. كيف يمكنني مساعدتك؟",
    "zh": "您好！感谢致电{business_name}。请问有什么可以帮您？",
}

UNIVERSAL_GREETING = """Hello! Thank you for calling.
Hola, gracias por llamar.
Bonjour, merci d'appeler.
How can I help you today?"""
```

## Prompt Engineering Best Practices

### 1. Keep It Conversational
```
❌ "Please state your order now."
✅ "What can I get started for you?"
```

### 2. Handle Interruptions Gracefully
```python
# In AgentSession config:
allow_interruptions=True

# In prompt:
"If the caller interrupts, acknowledge and adjust. Don't repeat yourself."
```

### 3. Concise Responses
```
❌ "I have successfully added one large pepperoni pizza to your order. Your current total is now $18.99. Is there anything else you would like to add?"
✅ "Got it, large pepperoni. That's $18.99. Anything else?"
```

### 4. Natural Confirmations
```
❌ "Order confirmed. Item added."
✅ "Perfect, I've added that."
```

### 5. Error Recovery
```python
# In prompt:
"""
If you make a mistake:
- Acknowledge it naturally: "Oh, let me fix that"
- Correct without over-apologizing
- Move forward smoothly
"""
```

## Adding New Languages

1. Add to `SYSTEM_PROMPTS` dict in the prompts file
2. Add greeting to `GREETINGS` dict
3. Update `SUPPORTED_LANGUAGES` in config
4. Test with native speakers for natural phrasing

## Domain-Specific Prompts

### Restaurant Orders (Example)
Focus: Menu navigation, order building, modifications

### Appointment Booking (Example)
```python
APPOINTMENT_PROMPT = """You are a scheduling assistant for {business_name}.

## Your Role
- Help callers book appointments
- Check availability
- Confirm booking details
- Handle rescheduling and cancellations

## Available Tools
- get_available_slots(date, service_type)
- book_appointment(customer_name, phone, date, time, service)
- cancel_appointment(appointment_id)
- reschedule_appointment(appointment_id, new_date, new_time)
"""
```

### Customer Support (Example)
```python
SUPPORT_PROMPT = """You are a support agent for {company_name}.

## Your Role
- Answer common questions
- Troubleshoot issues
- Escalate to human when needed
- Create support tickets

## Escalation Triggers
- Caller asks for human
- Issue requires account access
- Complaint about service
- Technical problem you can't resolve
"""
```

## Testing Prompts

### Test Scenarios to Cover
1. Simple request (one item)
2. Complex request (multiple items, modifications)
3. Information questions
4. Price/availability inquiries
5. Request modifications (add/remove)
6. Special requirements handling
7. Unclear speech handling
8. Language switching mid-call

### Latency Considerations
- Shorter prompts = faster LLM response
- Use bullet points over paragraphs
- Front-load important instructions
- Keep tool descriptions minimal

## Output Format

When creating/modifying prompts:
1. Update the prompts file in the agent directory
2. Test with sample conversations
3. Measure latency impact
4. Validate all language versions
