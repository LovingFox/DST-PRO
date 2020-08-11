import numpy as np


def score_game(game_core):
    '''
    Запускаем игру 1000 раз, чтобы узнать, как быстро игра
    угадываетчисло
    '''
    count_ls = []
    np.random.seed(1)  # фиксируем RANDOM SEED, было воспроизводимо!
    random_array = np.random.randint(1,101, size=(1000))
    for number in random_array:
        count_ls.append(game_core(number))
    score = int(np.mean(count_ls))
    print(f"Ваш алгоритм угадывает число в среднем за {score} попыток")
    return(score)


def game_core_v1(number):
    '''
    Просто угадываем на random, никак не используя информацию
    о больше или меньше.
    Функция принимает загаданное число и возвращает число попыток
    '''
    count = 0
    while True:
        count+=1
        predict = np.random.randint(1,101) # предполагаемое число
        if number == predict:
            return(count) # выход из цикла, если угадали


def game_core_v2(number):
    '''
    Сначала устанавливаем любое random число, а потом уменьшаем или
    увеличиваем его в зависимости от того, больше оно или меньше
    нужного. Функция принимает загаданное число и возвращает число
    попыток
    '''
    count = 1

    predict = np.random.randint(1,101)
    while number != predict:
        count+=1
        if number > predict: 
            predict += 1
        elif number < predict: 
            predict -= 1
    return(count) # выход из цикла, если угадали


def game_core_v3(number):
    '''
    Всем известный метод деления пополам. Берем середину возможных
    значений и движемся к результату по принципу "больше-меньше",
    отсекая лишнюю половину и работая с оставшейся.
    Функция принимает загаданное число и возвращает число попыток
    '''
    count = 1
    min_predict = 1
    max_predict = 101

    predict = 50
    while number != predict:
        count+=1
        if number > predict: 
            mid = (max_predict-predict)/2
            predict = round(mid) + predict
        elif number < predict: 
            max_predict = predict # ограничиваем верхнюю границу
            mid = (predict-min_predict)/2
            predict = round(mid) + min_predict
    return(count) # выход из цикла, если угадали


print("--- v1 ---")
score_game(game_core_v1)

print("--- v2 ---")
score_game(game_core_v2)

print("--- v3 ---")
score_game(game_core_v3)

