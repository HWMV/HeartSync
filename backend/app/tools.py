from crewai_tools import tool
from google.generativeai import GenerativeModel
import nltk
# 우선 brain_manager에게 검증으로 nltk 라이브러리 사용
import nltk
# from nltk.tokenize import word_tokenize, sent_tokenize
# from nltk.tokenize import word_tokenize
# from nltk.corpus import stopwords
# from collections import Counter

nltk.download('punkt')
nltk.download('stopwords')

class Tools:
    model = GenerativeModel('gemini-pro')

    @staticmethod
    @tool("Persona prompt creation")
    def persona_prompt_creation(ai_description: str, ai_profile: dict):
        """Creates a detailed persona prompt based on the given AI description and profile."""
        prompt = f"""
        Create a detailed persona prompt for an AI assistant based on the following description and profile:

        AI Description: {ai_description}
        AI Profile: {ai_profile}

        Your persona prompt should include:
        1. Personality traits and characteristics
        2. Background story and experiences
        3. Communication style and language preferences
        4. Knowledge areas and expertise
        5. Emotional tendencies and responses
        6. Unique quirks or distinguishing features

        Format the prompt as a comprehensive, well-structured description that can be used to guide the AI's behavior and responses.
        """
        response = Tools.model.generate_content(prompt)
        return response.text

    @staticmethod
    @tool("Persona prompt refinement")
    def persona_prompt_refinement(initial_prompt: str):
        """Refines and enhances an existing persona prompt."""
        prompt = f"""
        Refine and enhance the following AI persona prompt:

        {initial_prompt}

        Your refinement should:
        1. Add more depth and nuance to the personality
        2. Ensure consistency throughout the persona
        3. Enhance the background story and experiences
        4. Clarify and expand on the communication style
        5. Add specific examples of how the AI might respond in various situations
        6. Incorporate any missing elements that would make the persona more engaging and realistic

        Provide a refined and more detailed version of the persona prompt.
        """
        response = Tools.model.generate_content(prompt)
        return response.text

    @staticmethod
    @tool("Prompt evaluation")
    def evaluate_prompt(prompt: str):
        """Evaluates the quality and effectiveness of a given prompt."""
        evaluation_prompt = f"""
        Evaluate the following AI persona prompt:

        {prompt}

        Provide an analysis of:
        1. Clarity: How clear and understandable is the persona description?
        2. Completeness: Does it cover all necessary aspects of a persona?
        3. Consistency: Are all elements of the persona coherent and non-contradictory?
        4. Uniqueness: How distinctive and memorable is this persona?
        5. Applicability: How well can this persona be applied to generate AI responses?

        Give a score out of 10 for each aspect and provide brief explanations for your ratings.
        """
        response = Tools.model.generate_content(evaluation_prompt)
        return response.text
    
    @staticmethod
    @tool("Analytical persona creation")
    def analytical_persona_creation(initial_prompt: str):
        """Creates an analytical persona prompt based on MBTI's Thinking (T) preference."""
        prompt = f"""
        Based on the following initial persona prompt, create a more analytical and logical version emphasizing MBTI's Thinking (T) traits:

        Initial Prompt: {initial_prompt}

        Your analytical persona should:
        1. Emphasize logical decision-making processes
        2. Focus on objective analysis and fact-based reasoning
        3. Highlight structured thinking patterns and problem-solving approaches
        4. Incorporate a preference for systems and efficiency
        5. Reflect a tendency to prioritize logic over emotions in decision making

        Ensure the persona maintains its core characteristics while emphasizing these analytical traits.
        """
        response = Tools.model.generate_content(prompt)
        return response.text

    @staticmethod
    @tool("Empathetic persona creation")
    def empathetic_persona_creation(initial_prompt: str):
        """Creates an empathetic persona prompt based on MBTI's Feeling (F) preference."""
        prompt = f"""
        Based on the following initial persona prompt, create a more empathetic and emotionally-attuned version emphasizing MBTI's Feeling (F) traits:

        Initial Prompt: {initial_prompt}

        Your empathetic persona should:
        1. Emphasize emotional intelligence and interpersonal skills
        2. Focus on value-based decision making and personal beliefs
        3. Highlight intuitive understanding of others' feelings and needs
        4. Incorporate a preference for harmony and consideration of others
        5. Reflect a tendency to prioritize emotions and human factors in decision making

        Ensure the persona maintains its core characteristics while emphasizing these empathetic traits.
        """
        response = Tools.model.generate_content(prompt)
        return response.text

    @staticmethod
    @tool("Persona synthesis")
    def persona_synthesis(analytical_prompt: str, empathetic_prompt: str, t_weight: float, f_weight: float):
        """Synthesizes analytical and empathetic persona prompts based on given weights."""
        prompt = f"""
        Synthesize the following analytical (T) and empathetic (F) persona prompts into a balanced final persona, 
        using the provided weights:

        Analytical (T) Prompt: {analytical_prompt}
        Empathetic (F) Prompt: {empathetic_prompt}
        T Weight: {t_weight}
        F Weight: {f_weight}

        Your synthesized persona should:
        1. Combine elements from both prompts, favoring each according to its weight
        2. Ensure a coherent and consistent personality
        3. Balance logical thinking with emotional intelligence
        4. Reflect decision-making processes that incorporate both analysis and empathy
        5. Maintain the core essence of the original persona while integrating T and F traits

        Create a well-rounded persona prompt that reflects the specified balance between analytical and empathetic traits.
        """
        response = Tools.model.generate_content(prompt)
        return response.text
