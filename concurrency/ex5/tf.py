import re, sys, collections, os, threading, time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

class FrequencyCount:
    def __init__(self):
        self.frequencies = collections.Counter()
        self.lock = threading.Lock()
        self.exec = ThreadPoolExecutor(max_workers=13)
        self.stop_words = set()

    def process_path(self, filepath):
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                for line in f:
                    self.process_line(line)
        except Exception as e:
            print(f"Error processing file {filepath}: {e}")

    def process_line(self, line):
        try:
            words = re.findall(r'\w{3,}', line.lower())
            # Filter out stop words and update counter thread-safely
            with self.lock:
                for word in words:
                    if word not in self.stop_words:
                        self.frequencies[word] += 1
        except Exception as e:
            print(f"Error processing line: {e}")

    def count_words(self, words, stopwords):
        counts = collections.Counter(w for w in words if w not in stopwords)
        for (w, c) in counts.most_common(40):
            print(w, '-', c)
    
    def load_stop_words(self):
        try:
            self.stop_words = set(open('concurrency/ex5/stop_words').read().split(','))
        except Exception as e:
            print(f"error loading stop words: {e}")

    @staticmethod
    def main():
        fc = FrequencyCount()
        fc.load_stop_words()
        start = time.time_ns()
        try:
            base_dir = Path("concurrency/ex5")
            for filepath in base_dir.rglob('*.txt'):
                fc.exec.submit(fc.process_path, filepath)
                print('adding file: ', filepath)
        except Exception as e:
            print(f"error processing files: {e}")
        fc.exec.shutdown(wait=True)
        end = time.time_ns()
        elapsed = end - start
        print(f"Elapsed time: {elapsed // 1000000}ms")
        for (w, c) in fc.frequencies.most_common(40):
            print(w, '-', c)

FrequencyCount.main()        