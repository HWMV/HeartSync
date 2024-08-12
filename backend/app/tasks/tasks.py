from crewai import Task

class PersonaTasks:
    def create_persona_prompt(self, agent, ai_description: str, ai_profile: str):
        return Task(
            description=f"""Create a detailed persona prompt based on the following AI description and profile:
            AI Description: {ai_description}
            AI Profile: Gender: {ai_profile}
            
            Your task is to:
            1. Analyze the provided AI description to understand the desired personality and characteristics.
            2. Incorporate details from the AI profile, including gender, age, occupation, and MBTI type.
            3. Create a comprehensive persona prompt that captures the essence of the desired AI companion.
            4. Ensure the prompt is clear, specific, and provides a strong foundation for the AI's personality.

            The persona prompt should include:
            - Detailed personality traits and behaviors
            - Communication style and language preferences
            - Background story and life experiences
            - Interests, knowledge areas, and expertise
            - Emotional characteristics and tendencies
            - Specific traits or quirks mentioned in the description

            Format the prompt in a clear, structured manner that can be easily processed by AI models.""",
            agent=agent,
            expected_output="A comprehensive, well-structured persona prompt that captures the essence of the desired AI companion based on the provided description and profile."
        )

    # def refine_persona_prompt(self, agent, initial_prompt: str, ai_description):
    #     return Task(
    #         description=f"""Refine and enhance the following initial persona prompt:
    #         {initial_prompt}
    #         {ai_description}
            
    #         Your task is to:
    #         1. Review the initial prompt for completeness and coherence.
    #         2. Identify any areas that could be expanded or clarified.
    #         3. Ensure the persona is well-rounded and believable.
    #         4. Add any missing details that would make the AI persona more engaging and realistic.
    #         5. Adjust language and tone to perfectly match the desired AI personality.

    #         Focus on making the persona prompt as detailed and vivid as possible, while maintaining internal consistency.""",
    #         agent=agent,
    #         expected_output="An enhanced and refined persona prompt that is more detailed, vivid, and coherent than the initial prompt."
    #     )