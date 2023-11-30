#!/usr/bin/python3

def main():

    initial_value = 8

    delay_set = generate_pow_2_set(initial_value)

    delay_n_init = 128
    
    delay_n = delay_n_init

    m_light_select = 0xffa

    flashes_total = 16

    flashes_counter = 0

    while flashes_counter < flashes_total:

        delay_quantity = get_delay_quantity(delay_set, flashes_counter)

        m_light_str = generate_m_light_asm(m_light_select, flashes_counter)

        intro = "\n".join([
            f"\n\nflash_{delay_n}",
            "ADD max",
            "STA &0FFF"])

        first_delay = generate_delay_set(delay_n, 0, delay_quantity)

        second_delay = generate_delay_set(delay_n, 1, delay_quantity)

        print("\n\n".join([intro,
               first_delay,
               "STA &0FFF",
               second_delay,
               ]))

        delay_n -= 1

        flashes_counter += 1


def generate_m_light_asm(m_light_select, flashes_counter):

    m_light_select = get_next_m_light(m_light_select)

    m_light_pattern = get_next_m_light_pattern(flashes_counter)

    action_to_perform = flashes_counter % 12

    if action_to_perform < 6:

        return "\n".join[
            f"LDA {pattern}",
            
        load = True

    else:

        store = True

    

        
def get_next_m_light_pattern(flashes_counter):

    ##  n =>
    ##  [<data_to_write>, <data_to_erase>]

    if flashes_counter % 2 == 0:

        return = "m_pattern_a"

        # pattern = format_input_mu0(0b000000011101101)

    else:

        return = "m_pattern_b"

        # pattern = format_input_mu0(0b000000011101101)


def format_input_mu0(n):

    return hex(n).replace("0x", "&").upper()

        
def get_next_m_light(light_target):

    light_target -= 1

    if light_target < 0xff5:

        return 0xffa

    else:

        return light_target

    # return hex(light_target).replace("0x", "&").upper()


def get_delay_quantity(delay_set, flashes_counter):

    if flashes_counter < len(delay_set):

        return delay_set[flashes_counter]

    else:

        return 1
        

def generate_delay_set(delay_n, toggle, delay_quantity):

    delay_quantity_counter = 0

    delay_set = ""

    while delay_quantity_counter < delay_quantity:

        delay_set += generate_delay(delay_n, toggle, delay_quantity_counter)

        delay_quantity_counter += 1

    return delay_set

        
def generate_delay(delay_n, toggle, delay_quantity):

    delay_label = f"loop_delay_{delay_n}_{toggle}_{delay_quantity}"

    delay_asm = "\n".join(["LDA delay_max",
                 delay_label,
                 "sub one",
                 f"JNE {delay_label}"])
                 
    return delay_asm


def generate_pow_2_set(initial_value):

    delay_set = []

    v = initial_value

    while v > 0:

        delay_set.append(v)

        v = v // 2

    return delay_set


main()

