from typing import Dict, List, Any
from nltk.sentiment import SentimentIntensityAnalyzer
from langdetect import detect
import nltk

# konlpy 설치 완료 추후 성능 개선을 위해 vader 대신 konlpy 사용해보자
nltk.download('vader_lexicon')

class EmotionAnalyzer:
    def __init__(self):
        self.sia = SentimentIntensityAnalyzer()
        self.ko_pos_words: set = {'행복', '기쁨', '사랑', '좋아', '긍정', '훌륭'}
        self.ko_neg_words: set = {'슬픔', '화남', '미움', '나쁨', '부정', '최악'}

    def analyze_emotion(self, text: str) -> Dict[str, float]:
        lang: str = detect(text)
        if lang == 'ko':
            return self.analyze_korean(text)
        else:
            return self.analyze_english(text)

    def analyze_english(self, text: str) -> Dict[str, float]:
        sentiment_scores: Dict[str, float] = self.sia.polarity_scores(text)
        
        emotions: Dict[str, float] = {
            "joy": max(sentiment_scores.get('pos', 0) - 0.1, 0) * 2,
            "sadness": max(sentiment_scores.get('neg', 0) - 0.1, 0) * 2,
            "anger": max(sentiment_scores.get('neg', 0) - 0.2, 0) * 2,
            "anxiety": max(sentiment_scores.get('neu', 0) - 0.3, 0),
            "affection": max(sentiment_scores.get('pos', 0) - 0.2, 0) * 2
        }
        
        return self.normalize_emotions(emotions)

    def analyze_korean(self, text: str) -> Dict[str, float]:
        words: List[str] = text.split()  # 공백을 기준으로 단어 분리
        
        pos_score: int = sum(1 for word in words if word in self.ko_pos_words)
        neg_score: int = sum(1 for word in words if word in self.ko_neg_words)
        
        total: int = pos_score + neg_score
        if total == 0:
            return {
                "joy": 0.2, "sadness": 0.2, "anger": 0.2, "anxiety": 0.2, "affection": 0.2
            }
        
        pos_ratio: float = pos_score / total
        neg_ratio: float = neg_score / total
        
        emotions: Dict[str, float] = {
            "joy": pos_ratio * 0.6,
            "sadness": neg_ratio * 0.3,
            "anger": neg_ratio * 0.3,
            "anxiety": neg_ratio * 0.2,
            "affection": pos_ratio * 0.4
        }
        
        return self.normalize_emotions(emotions)

    def normalize_emotions(self, emotions: Dict[str, float]) -> Dict[str, float]:
        total: float = sum(emotions.values())
        if total > 0:
            return {k: v/total for k, v in emotions.items()}
        return emotions

    def get_dominant_emotion(self, emotions: Dict[str, float]) -> str:
        return max(emotions, key=emotions.get)  # type: ignore