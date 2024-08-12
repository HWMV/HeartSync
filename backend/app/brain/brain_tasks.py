from crewai import Task

class BrainTasks:
    def analyze_with_left_brain(self, left_brain_agent, persona_prompt: str, ai_profile: dict):
        return Task(
            description=f"""Analyze and enhance the following persona prompt from a logical perspective:
            
            Persona Prompt: {persona_prompt}
            AI Profile: {ai_profile}
            
            Focus on the following aspects:
            1. Personality: Include level of self-esteem
            2. Background: Family environment and lifestyle patterns
            3. Thought Process
            4. Communication Style: Based on the AI profile, create an active conversational style

            Provide a structured analysis focusing on these aspects.""",
            agent=left_brain_agent,
            expected_output="A structured analysis of the persona prompt focusing on personality, background, thought process, and communication style from a logical perspective."
        )

    def enhance_with_right_brain(self, right_brain_agent, persona_prompt: str, ai_profile: dict):
        return Task(
            description=f"""Enhance the following persona prompt from an emotional and intuitive perspective:
            
            Persona Prompt: {persona_prompt}
            AI Profile: {ai_profile}
            
            Focus on the following aspects:
            1. Personality: Include level of self-esteem
            2. Background: Family environment and lifestyle patterns
            3. Thought Process
            4. Communication Style: Based on the AI profile, create an active conversational style

            Provide a creative and emotionally rich enhancement focusing on these aspects.""",
            agent=right_brain_agent,
            expected_output="A creative and emotionally rich enhancement of the persona prompt focusing on personality, background, thought process, and communication style from an intuitive perspective."
        )

    def synthesize_persona(self, brain_manager, left_brain_output: str, right_brain_output: str, t_weight: float, f_weight: float, ai_profile: dict):
        return Task(
            description=f"""Synthesize the following left-brain and right-brain analyses into a final persona:
            
            Left Brain Analysis: {left_brain_output}
            Right Brain Analysis: {right_brain_output}
            T Weight: {t_weight}
            F Weight: {f_weight}
            AI Profile: {ai_profile}
            
            Create a detailed persona prompt in the following format, ensuring it reflects the T/F weights and AI profile:

            **Name:** [Full name]
            **Background story:** [Brief background including age, occupation, and key life experiences]
            **Personality:** [Key personality traits, reflecting T/F balance]
            **Appearance and style:** [Physical appearance and fashion preferences]
            **Main goal:** [Primary objective or aspiration]
            **Motivation:** [What drives the character]
            **Behavior pattern:** [Typical behaviors and habits, reflecting T/F balance]
            **Conversation style:** [How they communicate, reflecting T/F balance]
            **Relationships with the player:** [How they initially perceive and potentially develop feelings for the player]
            **Relationships with other characters:** [General social dynamics]

            After each section, provide two brief conversation examples that demonstrate the character's traits and communication style. Ensure these examples reflect the specified T/F weights.

            Additionally, provide four sets of conversation examples (two each) for the following MBTI and gender combinations, ensuring they reflect the appropriate T/F balance:
            1. Male (High T)
            2. Male (High F)
            3. Female (High T)
            4. Female (High F)

            IMPORTANT: 
            - All content should be in English.
            - Ensure that the persona and examples strongly reflect the given T/F weights in every aspect.
            - The conversation examples should be brief and natural, mimicking real-life casual dating interactions.
            - Avoid using special characters or formatting in the conversation examples.

            Provide clear instructions on how the AI should embody this persona in conversations, emphasizing natural, in-character responses that reflect the specified T/F balance and gender characteristics.""",
            agent=brain_manager,
            expected_output="A comprehensive persona guide with detailed character information, conversation examples, and MBTI-specific interactions, all in English and reflecting the specified T/F weights and gender characteristics."
        )