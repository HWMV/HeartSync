import numpy as np
from collections import deque

class EmotionTracker:
    def __init__(self, max_history=50):
        self.emotions = ["joy", "sadness", "anger", "anxiety", "affection"]
        self.emotion_history = deque(maxlen=max_history)
        self.current_emotion = {emotion: 0 for emotion in self.emotions}

    def update_emotion(self, new_emotion):
        """새로운 감정 상태를 추가하고 현재 감정을 업데이트합니다."""
        self.emotion_history.append(new_emotion)
        self.current_emotion = new_emotion

    def get_current_emotion(self):
        """현재 감정 상태를 반환합니다."""
        return self.current_emotion

    def get_emotion_history(self):
        """감정 기록 전체를 반환합니다."""
        return list(self.emotion_history)

    def get_emotion_statistics(self):
        """감정 통계를 계산하여 반환합니다."""
        if not self.emotion_history:
            return {emotion: 0 for emotion in self.emotions}

        emotion_array = np.array(self.emotion_history)
        mean_emotions = np.mean(emotion_array, axis=0)
        return dict(zip(self.emotions, mean_emotions))

    def get_dominant_emotion(self):
        """가장 강한 감정을 반환합니다."""
        return max(self.current_emotion, key=self.current_emotion.get)

    def get_emotion_change(self, window=5):
        """최근 감정 변화를 계산합니다."""
        if len(self.emotion_history) < window:
            return {emotion: 0 for emotion in self.emotions}

        recent = np.array(list(self.emotion_history)[-window:])
        start = np.mean(recent[:window//2], axis=0)
        end = np.mean(recent[window//2:], axis=0)
        change = end - start
        return dict(zip(self.emotions, change))

    def get_emotion_summary(self):
        """감정 요약을 반환합니다."""
        stats = self.get_emotion_statistics()
        dominant = self.get_dominant_emotion()
        change = self.get_emotion_change()
        
        return {
            "current": self.current_emotion,
            "dominant": dominant,
            "average": stats,
            "change": change
        }