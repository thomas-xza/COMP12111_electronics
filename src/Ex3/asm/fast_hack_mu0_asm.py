#!/usr/bin/python3

def main():

    iter_flash = 3

    iter_time = 0

    middle = "\t\tSTA &0FFF\n"

    
    delay_time = []

    quantity = 2
    
    for i in range(quantity+1, 0, -1):

        delay_time.append(i**2)
        

    while iter_flash < iter_flash + quantity - 1:

        intro = f"flash_{iter_flash}\n" + \
            "\t\tADD max                 ;  add max to ACC\n" + \
            "\t\tSTA &0FFF               ;  store to memory &0FFF\n"

        delay_1 = generate_delay(iter_flash, delay_time[iter_time], "0")
        
        delay_2 = generate_delay(iter_flash, delay_time[iter_time], "1")

        print(intro + delay_1 + middle + delay_2 + "\n\n")

        iter_flash += 1

        iter_time += 1

        


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
