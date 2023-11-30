#!/usr/bin/python3

def main():

    store = "\t\tSTA &0FFF\n"

    delay_times = generate_delay_times()

    quantity_of_full_flashes = 3

    
    
        intro = f"flash_{iter_flash}\n" + \
            "\t\tADD max                 ;  add max to ACC\n" + store

        delay_1 = generate_delay(iter_flash, delay_time[iter_time], "0")
        
        delay_2 = generate_delay(iter_flash, delay_time[iter_time], "1")

        # print(intro + store + delay_1 + store + delay_2 + "\n\n")

        iter_time += 1


def generate_delay_times():

    delay_times = []

    while i < 16:

        delay_times.append(i)

        i = i * 2

    delay_times.reverse()

    return delay_times

        
def generate_delay(iter_flash, iter_time, toggle):

    counter = 0

    final_str = ""

    while ( counter < iter_time ):

        final_str += "\t\tLDA delay_max\n" + \
        f"loop_delay_{iter_flash}_{counter}_{toggle}\t\tsub one\n" + \
        "\t\tJNE loop_delay_4_1\n"

        counter += 1

    return final_str


main()
