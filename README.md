# DST-PRO
Проекты по курсу ***SkillFactory Data Scientist*** в обратном порядке (в начале те, что выполнены последними)
<hr>


##  Проект 4. Авиарейсы без потерь
#### Задача проекта
Нужно выяснить, от каких самых малоприбыльных рейсов из Анапы можно отказаться в зимнее время. Нет информации, по каким критериям будут отбирать рейсы, поэтому решено собрать как можно больше информации из базы данных, в один датасет.
Исходя из того, что прибыльность рейса — это разница между доходом от продаж билетов и расходом на полет, нужно соберать такой датасет, который позволит оценить эти цифры.

#### Файлы проекта (в директории *module_4*)
- *project4.sql* -- код SQL, используемый для составления итогового датасета;
- *dataset.csv* -- итоговый датасет;
- *tasks.sql* -- код SQL, используемый при выполнении заданий на Платформе.

[Ссылка на презентацию проекта (на Google Drive)](https://drive.google.com/file/d/1_FHz0QDpsisdbcOSJdKZD2RrJc6WNpGJ/view?usp=sharing)
<hr>


##  Проект 3. О вкусной и здоровой пище
#### Запуск
Загрузить в Jupiter Notebook файл *baseline-sf-tripadvisor-rating-v2-7-revyakin.ipynb* из директории *module_3*.

#### Задача проекта
Решить настоящий кейс и создадите первую модель, использующую алгоритмы машинного обучения. Одна из проблем компании TripAdvisor -- это нечестные рестораны, которые накручивают себе рейтинг. Одним из способов нахождения таких ресторанов является построение модели, которая предсказывает рейтинг ресторана. Если предсказания модели сильно отличаются от фактического результата, то, возможно, ресторан играет нечестно, и его стоит проверить.

Обработка описана в Ноутбуке (см. "Класс для обработки")
<hr>


## Проект 2. Разведывательный анализ данных
#### Запуск
Загрузить в Jupiter Notebook файл *edu.ipynb* из директории *module_2*.

#### Задача проекта
Провести разведывательный анализ данных и составьте отчёт по его результатам. Данные -- это информация по ученикам от 15 до 22 лет с результатами госэкзамена по математике.

Ход действий и рассуждений дан в Ноутбуке
<hr>


## Проект 1. Кто хочет стать миллионером кинопроката?
#### Запуск
Загрузить в Jupiter Notebook файл *Movies_IMBD_v4.1_Revyakin_Ivan.ipynb* из директории *module_1*.

#### Задача проекта
Ответить на поставленные вопросы на основе статистических данных по фильмам за период c 2000 по 2015 годы

#### Количество набранных в викторине баллов;
27


#### Ответы на вопросы саморефлексии:
*1. Какова была ваша роль в команде?*
В данном задании командная работа не отрабатывалась.

*2. Какой частью своей работы вы остались особенно довольны?*
Наверно, попытка оформить код покрасивее.

*3. Что не получилось сделать так, как хотелось? Над чем ещё стоит поработать?*
Сделать автоматическое выставление ответов в переменную *answer*. Скорей не не получилось, а поленился переносить варианты ответов в словарь, что бы автоматически сверять свой ответ с ними. А поработать нужно над изучением методов библиотек, что бы не отвлекаться на изобретение своих велосипедов, а больше решать поставленную бизнес-задачу. 

*4. Что интересного и полезного вы узнали в этом модуле?*
Узнал про модуль *itertools*. С его помощью получилось просто сделать комбинацию актеров для вопроса №27.

*5. Что является вашим главным результатом при прохождении этого проекта?*
Тренировка в обработке таблицы при помощи модулей Python.

*6. Планируете ли вы менять стратегию изучения последующих модулей?*
Думаю, что нет.

## Проект 0. GitHub. Самый быстрый старт
Игра "*Угадай число!*"
Улучшенная версия - v3

#### Запуск
```sh
$ cd module_0
$ python guess_number.py
```
