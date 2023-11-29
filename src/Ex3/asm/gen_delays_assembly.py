#!/usr/bin/python3

def main():

    initial_value = 8

    delay_set = generate_pow_2_set(initial_value)

    delay_n_init = len(delay_set) + 2
    
    delay_n = delay_n_init

    print(delay_set)

    for delay_quantity in delay_set:

        intro = [
            f"flash_{delay_n}",
            "ADD max",
            "STA &0FFF"].join("\n")

        first_delay = generate_delay_set(delay_n, 0, delay_quantity)

        second_delay = generate_delay_set(delay_n, 1, delay_quantity)

        delay_n -= 1

        print([intro,
               first_delay,
               "STA &0FFF",
               second_delay,
               ].join("\n"))


def generate_delay_set(delay_n, toggle, delay_quantity):

    delay_quantity_counter = 0

    delay_set = ""

    while delay_quantity_counter < delay_quantity:

        delay_set += generate_delay(delay_n, toggle, delay_quantity_counter)

        delay_quantity_counter += 1

    return delay_set

        
def generate_delay(delay_n, toggle, delay_quantity):

    delay_label = f"loop_delay_{delay_n}_{toggle}_{delay_quantity}"

    delay_asm = ["LDA delay_max",
                 delay_label,
                 "sub one",
                 f"JNE {delay_label}"].join("\n")
                 
    return delay_asm


def generate_pow_2_set(initial_value):

    delay_set = []

    v = initial_value

    while v > 0:

        delay_set.append(v)

        v = v // 2

    return delay_set



main()

