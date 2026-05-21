# Анализ транзакций контрагентов

## Ветка: A — Data / ML

## Быстрый старт
```
git clone https://github.com/Alim1512/da_project.git
cd da_project
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```
Положите входные файлы в папку `data/`:
- `data/transactions.csv`
- `data/categories.json`
- `data/gold_set.csv`

Запуск ноутбука:
```
jupyter notebook notebooks/analysis.ipynb
```
Выполните Kernel → Restart & Run All

## Структура репозитория
- `notebooks/analysis.ipynb` — EDA, очистка, SQL, ML
- `sql/queries.sql` — три SQL запроса с window-функциями
- `src/model.pkl` — обученная модель LogisticRegression
- `src/vectorizer.pkl` — TF-IDF векторайзер
- `requirements.txt` — зависимости

## Входные файлы
Не коммитятся в репозиторий. Положить в `data/` перед запуском.

## Выводы

### EDA
1. Датасет содержит 80,800 транзакций за период 2024-01 — 2026-04
2. Уникальных контрагентов: 7,215 (6,140 отправителей, 6,099 получателей)
3. Общий оборот: 164 млрд KZT, медиана транзакции: 324,097 KZT
4. Топ отправитель (720221554469): 755 млн KZT исходящих
5. Аномалия 1: 384 транзакции с отрицательными суммами (возвраты/ошибки)
6. Аномалия 2: даты в 4 форматах — ISO, слэш, точка, dd/mm/yyyy (34,566 строк, 42.8%)
7. Аномалия 3: 1,190 невалидных sender_id и 1,126 невалидных receiver_id по алгоритму РК

### Очистка
8. После очистки: 80,000 строк (удалено 800 дубликатов)
9. Все даты приведены к ISO 8601, все форматы распознаны успешно

### ML классификация (Ветка A)
10. Keyword baseline: Accuracy 83%, Macro F1 0.80
11. TF-IDF + LogisticRegression + rule-based: Accuracy 100%, Macro F1 1.00 на gold_set (200/200)
12. Систематическая путаница baseline: 62.01 ↔ 35.30/69.20/10.71 (слово 'поставка')
13. Систематическая путаница baseline: 69.10 ↔ 70.22 (слово 'консультац' в обоих)
14. Порог ручной проверки: confidence < 0.6

### SQL
15. Топ пара контрагентов: 960819662090 → 711020691210, оборот 297 млн KZT
16. Контрагентов с концентрацией входящих >70% от одного источника: 20+
    максимальная концентрация: 96.8%

## Стек
Python 3.13 · pandas · scikit-learn · SQLite · TF-IDF · LogisticRegression · matplotlib · seaborn
