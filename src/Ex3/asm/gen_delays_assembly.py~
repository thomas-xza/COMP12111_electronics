#!/usr/bin/python3

def main():

    initial_value = 8

    delay_set = generate_pow_2_set(initial_value)

    delay_n_init = len(delay_set) + 2
    
    delay_n = delay_n_init

    print(delay_set)

    for delay_quantity in delay_set:

        intro = f"flash_{delay_n}\n" + "enable light\n"

        first_delay = generate_delay_set(delay_n, 0, delay_quantity)

        second_delay = generate_delay_set(delay_n, 1, delay_quantity)

        delay_n -= 1

        print(intro, first_delay, "disable light\n", second_delay, "\n\n")

        # final_str = ""

        # counter = 0


def generate_delay_set(delay_n, toggle, delay_quantity):

    delay_quantity_counter = 0

    delay_set = ""

    while delay_quantity_counter < delay_quantity:

        delay_set += generate_delay(delay_n, toggle, delay_quantity_counter)

        delay_quantity_counter += 1

    return delay_set

        
def generate_delay(delay_n, toggle, delay_quantity):

    output_str = f"loop_delay_{delay_n}_{toggle}_{delay_quantity}\n"
    
    # output_str = "load max"

    # output_str += f"loop_delay_{delay_n}_{delay_quantity}_{toggle} sub one"

    # output_str += f"JNE loop_delay_{delay_n}_{delay_quantity}_{toggle}"

    return output_str


def generate_pow_2_set(initial_value):

    delay_set = []

    v = initial_value

    while v > 0:

        delay_set.append(v)

        v = v // 2

    return delay_set



main()

