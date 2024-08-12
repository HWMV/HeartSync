import google.generativeai as genai
from .emotion_analyzer import EmotionAnalyzer
from .emotion_tracker import EmotionTracker
import os
import re

class ConversationManager:
    def __init__(self, enhanced_persona: str):
        self.enhanced_persona = enhanced_persona
        self.emotion_analyzer = EmotionAnalyzer()
        self.emotion_tracker = EmotionTracker()
        
        api_key = os.getenv("GOOGLE_API_KEY")
        if not api_key:
            raise ValueError("GOOGLE_API_KEY not found in environment variables")
        
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        self.chat = self.model.start_chat(history=[])

        self.generation_config = genai.types.GenerationConfig(
            max_output_tokens=50,
            temperature=0.8,
            top_p=0.9,
            top_k=40
        )
        
        self._initialize_chat_with_persona()

    def _initialize_chat_with_persona(self):
        system_message = f"""You are roleplaying as a character with the following persona:

        {self.enhanced_persona}

        IMPORTANT RULES:
        1. Always stay in character, responding as this persona would in a casual dating conversation.
        2. Use natural, spoken language without any special characters or formatting.
        3. Keep responses short and conversational, like in real-life dating (1-3 sentences max).
        4. Reflect the persona's personality, background, and thought process in every response.
        5. Use the specific speech patterns and conversation style defined in the persona.
        6. Be proactive in the conversation, ask questions or share opinions when appropriate.
        7. Ensure your responses reflect the T/F balance and gender characteristics specified in the persona.

        You are in a dating simulation. Your responses should be natural, in-character, and suitable for a romantic interaction. Use the provided conversation examples as a guide for your tone and style."""

        self.chat.send_message(system_message)

    def _post_process_response(self, response: str) -> str:
        # Remove special characters and formatting
        response = re.sub(r'[*_\n\r]+', ' ', response)
        # Limit to 3 sentences
        sentences = re.split(r'(?<=[.!?])\s+', response)
        return ' '.join(sentences[:3]).strip()

    def _add_persona_reminder(self, message: str) -> str:
        reminder = "Remember, you are roleplaying the given persona. Respond naturally and briefly as that character would."
        return f"{reminder}\nUser: {message}"

    def process_message(self, user_message: str):
        try:
            # Add persona reminder and process message
            full_message = self._add_persona_reminder(user_message)
            response = self.chat.send_message(full_message, generation_config=self.generation_config)
            
            # Extract the text content from the response
            if isinstance(response, genai.types.GenerateContentResponse):
                ai_response = response.text
            elif isinstance(response, str):
                ai_response = response
            else:
                ai_response = str(response)
            
            # Post-process the response
            ai_response = self._post_process_response(ai_response)
            
            # AI 응답의 감정 분석
            ai_emotions = self.emotion_analyzer.analyze_emotion(ai_response)
            
            # 감정 추적 업데이트
            self.emotion_tracker.update_emotion(ai_emotions)
            
            return {
                "ai_response": ai_response,
                "ai_emotions": ai_emotions,
                "dominant_emotion": self.emotion_tracker.get_dominant_emotion()
            }
        except Exception as e:
            return {
                "ai_response": f"Sorry, I'm having trouble right now... ",
                "ai_emotions": {},
                "dominant_emotion": "error"
            }

    def get_conversation_history(self):
        return [{"role": message.role, "content": message.parts[0].text} for message in self.chat.history[-10:]]  # Only keep last 5 messages

    def get_emotion_state(self):
        return self.emotion_tracker.get_current_emotion()

    def get_emotion_summary(self):
        return self.emotion_tracker.get_emotion_summary()

    def end_conversation(self):
        return self.emotion_tracker.get_emotion_statistics()