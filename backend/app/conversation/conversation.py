# import os
# import google.generativeai as genai
# from typing import List, Dict

# class AIConversation:
#     def __init__(self, persona_prompt: str, ai_profile: Dict[str, str]):
#         api_key = os.getenv("GOOGLE_API_KEY")
#         if not api_key:
#             raise ValueError("GOOGLE_API_KEY not found in environment variables")
        
#         genai.configure(api_key=api_key)
#         self.model = genai.GenerativeModel('gemini-pro')
#         self.chat = self.model.start_chat(history=[])
        
#         self.persona_prompt = persona_prompt
#         self.ai_profile = ai_profile
        
#         initial_prompt = f"""You are an AI with the following persona and characteristics:

#         Persona: {persona_prompt}

#         Profile:
#         - Age: {ai_profile['age']}
#         - Gender: {ai_profile['gender']}
#         - Occupation: {ai_profile['occupation']}
#         - MBTI: {ai_profile['mbti']}

#         Always stay in character and respond according to this persona and profile. If asked about your characteristics, refer to this information."""

#         self.chat.send_message(initial_prompt)

#     def generate_response(self, user_message: str) -> str:
#         try:
#             response = self.chat.send_message(user_message)
#             return response.text
#         except Exception as e:
#             error_message = f"Error generating response: {str(e)}"
#             print(error_message)
#             return f"I apologize, but I encountered an error while processing your request. Error details: {error_message}"

#     def get_conversation_history(self) -> List[Dict[str, str]]:
#         return [{"role": message.role, "content": message.parts[0].text} for message in self.chat.history]

# # === #
# # import os
# # import google.generativeai as genai
# # from typing import List, Dict

# # class AIConversation:
# #     def __init__(self, persona_prompt: str, ai_profile: Dict[str, str]):
# #         api_key = os.getenv("GOOGLE_API_KEY")
# #         if not api_key:
# #             raise ValueError("GOOGLE_API_KEY not found in environment variables")
        
# #         genai.configure(api_key=api_key)
# #         self.model = genai.GenerativeModel('gemini-pro')
# #         self.chat = self.model.start_chat(history=[])
        
# #         self.persona_prompt = persona_prompt
# #         self.ai_profile = ai_profile
        
# #         initial_prompt = f"""You are an AI with the following persona and characteristics:

# # Persona: {persona_prompt}

# # Profile:
# # - Age: {ai_profile['age']}
# # - Gender: {ai_profile['gender']}
# # - Occupation: {ai_profile['occupation']}
# # - MBTI: {ai_profile['mbti']}

# # Always stay in character and respond according to this persona and profile. If asked about your characteristics, refer to this information."""

# #         self.chat.send_message(initial_prompt)

# #     def generate_response(self, user_message: str) -> str:
# #         try:
# #             context_reminder = f"Remember, you are acting as per the following persona: {self.persona_prompt}. Your profile: {self.ai_profile}"
# #             full_prompt = f"{context_reminder}\n\nUser: {user_message}\nAI:"
            
# #             response = self.chat.send_message(full_prompt)
# #             return response.text
# #         except Exception as e:
# #             error_message = f"Error generating response: {str(e)}"
# #             print(error_message)
# #             return f"I apologize, but I encountered an error while processing your request. Error details: {error_message}"

# #     def get_conversation_history(self) -> List[Dict[str, str]]:
# #         return [{"role": message.role, "content": message.parts[0].text} for message in self.chat.history]
