import os
import uuid
from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Dict, Literal
from langchain_google_genai import ChatGoogleGenerativeAI
from crewai import Crew
from agents.agents import Agents
from tasks.tasks import PersonaTasks
from brain.brain_agents import BrainAgents
from brain.brain_tasks import BrainTasks
from conversation.conversation_manager import ConversationManager
from dotenv import load_dotenv
import logging

load_dotenv()

app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

google_api_key = os.environ.get('GOOGLE_API_KEY')
if not google_api_key:
    raise ValueError("GOOGLE_API_KEY not found in environment variables")

llm = ChatGoogleGenerativeAI(model="gemini-pro")

class AIProfile(BaseModel):
    age: int = Field(..., ge=1, le=100)
    gender: Literal["man", "woman", "other"]
    occupation: str = Field(..., min_length=1)
    mbti: str = Field(..., min_length=4, max_length=4)

class GeneratePersonaInput(BaseModel):
    ai_description: str = Field(..., min_length=1)
    ai_profile: AIProfile

class EnhancePersonaInput(BaseModel):
    persona_prompt: str = Field(..., min_length=1)
    ai_profile: AIProfile
    t_weight: float = Field(..., ge=0, le=1)
    f_weight: float = Field(..., ge=0, le=1)

class StartChatRequest(BaseModel):
    enhance_persona: str

class UserMessage(BaseModel):
    message: str

chat_sessions: Dict[str, ConversationManager] = {}

# 세션 관리를 위함
def get_conversation_manager(session_id: str):
    if session_id not in chat_sessions:
        raise HTTPException(status_code=400, detail=f"Invalid session ID: {session_id}. Please start a new chat.")
    return chat_sessions[session_id]

# 엔드포인트 핸들러
@app.get("/")
def read_root():
    return {"message": "Welcome to HeartSync App API"}

@app.post("/generate_persona")
async def generate_persona(input_data: GeneratePersonaInput):
    try:
        agents = Agents(google_api_key)
        tasks = PersonaTasks()
        persona_creator = agents.persona_creator_agent()
        persona_task = tasks.create_persona_prompt(
            persona_creator,
            input_data.ai_description,
            input_data.ai_profile.model_dump()
        )
        initial_prompt = Crew(agents=[persona_creator], tasks=[persona_task], verbose=True).kickoff()
        return {"persona_prompt": str(initial_prompt)}
    except Exception as e:
        logger.error(f"Error in generate_persona: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/enhance_persona")
async def enhance_persona(input_data: EnhancePersonaInput):
    try:
        if abs(input_data.t_weight + input_data.f_weight - 1) > 1e-6:
            raise ValueError("Sum of t_weight and f_weight should be 1")

        brain_agents = BrainAgents(google_api_key)
        brain_tasks = BrainTasks()

        left_brain = brain_agents.left_brain()
        right_brain = brain_agents.right_brain()
        brain_manager = brain_agents.brain_manager()

        left_task = brain_tasks.analyze_with_left_brain(left_brain, input_data.persona_prompt, input_data.ai_profile.model_dump())
        right_task = brain_tasks.enhance_with_right_brain(right_brain, input_data.persona_prompt, input_data.ai_profile.model_dump())

        left_output = Crew(agents=[left_brain], tasks=[left_task], verbose=True).kickoff()
        right_output = Crew(agents=[right_brain], tasks=[right_task], verbose=True).kickoff()

        synthesis_task = brain_tasks.synthesize_persona(
            brain_manager, str(left_output), str(right_output), 
            input_data.t_weight, input_data.f_weight,
            input_data.ai_profile.model_dump()
        )
        final_prompt = Crew(agents=[brain_manager], tasks=[synthesis_task], verbose=True).kickoff()

        return {"enhance_persona": str(final_prompt)}
    except ValueError as ve:
        raise HTTPException(status_code=400, detail=str(ve))
    except Exception as e:
        logger.error(f"Error in enhance_persona: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# 엔드포인트 정의
@app.post("/start_chat")
async def start_chat(request: StartChatRequest):
    try:
        session_id = str(uuid.uuid4())  # UUID를 사용하여 고유한 세션 ID 생성
        chat_sessions[session_id] = ConversationManager(request.enhance_persona)
        logger.info(f"New chat session started: {session_id}")
        return {"message": "Chat started successfully", "session_id": session_id}
    except Exception as e:
        logger.error(f"Failed to start chat: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Failed to start chat: {str(e)}")

@app.post("/send_message")
async def send_message(user_message: UserMessage, session_id: str, conversation_manager: ConversationManager = Depends(get_conversation_manager)):
    try:
        result = conversation_manager.process_message(user_message.message)
        logger.info(f"Message processed for session {session_id}")
        return result
    except Exception as e:
        logger.error(f"Error processing message for session {session_id}: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error processing message: {str(e)}")

@app.get("/get_emotion_state")
async def get_emotion_state(session_id: str, conversation_manager: ConversationManager = Depends(get_conversation_manager)):
    try:
        emotion_state = conversation_manager.get_emotion_state()
        logger.info(f"Emotion state retrieved for session {session_id}")
        return emotion_state
    except Exception as e:
        logger.error(f"Error getting emotion state for session {session_id}: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error getting emotion state: {str(e)}")

@app.post("/end_conversation")
async def end_conversation(session_id: str, conversation_manager: ConversationManager = Depends(get_conversation_manager)):
    try:
        final_affinity = conversation_manager.end_conversation()
        del chat_sessions[session_id]
        logger.info(f"Conversation ended for session {session_id}")
        return {"final_affinity": final_affinity}
    except Exception as e:
        logger.error(f"Error ending conversation for session {session_id}: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error ending conversation: {str(e)}")
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)