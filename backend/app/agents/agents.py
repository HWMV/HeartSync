from crewai import Agent
from tools import Tools

from crewai import Agent
from langchain_google_genai import ChatGoogleGenerativeAI

class Agents:
    def __init__(self, api_key):
        self.llm = ChatGoogleGenerativeAI(model="gemini-pro", google_api_key=api_key)
        self.tools = Tools()

    def persona_creator_agent(self):
        return Agent(
            role="Persona Creator",
            goal="Create an initial persona prompt based on user-provided AI description and profile",
            backstory="You are an expert in crafting detailed and engaging AI persona prompts based on given descriptions and profiles.",
            verbose=True,
            allow_delegation=False,
            llm=self.llm,
            tools=[self.tools.persona_prompt_creation]
        )

    def persona_refinement_agent(self):
        return Agent(
            role="Persona Refinement Specialist",
            goal="Refine and enhance the initial persona prompt to create a more detailed and coherent AI personality",
            backstory="""You are a specialist in perfecting AI personas. Your keen eye for detail and understanding of 
            complex personalities allows you to take an initial prompt and transform it into a rich, nuanced description 
            of an AI companion. You ensure that all aspects of the persona are consistent and well-developed.""",
            verbose=True,
            allow_delegation=False,
            llm=self.llm,
            tools=[self.tools.persona_prompt_refinement]
        )