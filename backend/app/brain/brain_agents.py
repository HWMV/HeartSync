from crewai import Agent
from tools import Tools
from langchain_google_genai import ChatGoogleGenerativeAI

class BrainAgents:
    def __init__(self, api_key):
        self.llm = ChatGoogleGenerativeAI(model="gemini-pro", google_api_key=api_key)
        self.tools = Tools()

    def left_brain(self):
        return Agent(
            role="Analytical Persona Creator (T)",
            goal="Create a logical and analytical persona prompt based on MBTI's Thinking (T) preference",
            backstory="""You are the logical left brain, specialized in creating analytical and thought-oriented persona prompts. 
            Your strength lies in emphasizing rational decision-making, objective analysis, and structured thinking patterns.""",
            tools=[self.tools.analytical_persona_creation],
            allow_delegation=False,
            verbose=True,
            llm=self.llm,
        )

    def right_brain(self):
        return Agent(
            role="Empathetic Persona Creator (F)",
            goal="Create an intuitive and emotional persona prompt based on MBTI's Feeling (F) preference",
            backstory="""You are the intuitive right brain, focused on creating emotional and empathy-driven persona prompts. 
            Your strength is in capturing feelings, personal values, and interpersonal harmony in the AI's personality.""",
            tools=[self.tools.empathetic_persona_creation],
            allow_delegation=False,
            verbose=True,
            llm=self.llm,
        )
    
    def brain_manager(self):
        return Agent(
            role="Persona Synthesis Manager",
            goal="Integrate and optimize the persona prompts from both brain hemispheres",
            backstory="""You are an expert in balancing and synthesizing logical and emotional inputs to produce a well-rounded AI persona. 
            Your role is to ensure that the final persona prompt combines analytical and empathetic traits according to the specified weights.""",
            tools=[self.tools.persona_synthesis],
            allow_delegation=False,
            verbose=True,
            llm=self.llm,
        )