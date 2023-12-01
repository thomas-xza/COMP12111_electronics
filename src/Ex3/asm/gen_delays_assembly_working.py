#!/usr/bin/python3

def main():

    initial_value = 16

    delay_set = generate_pow_2_set(initial_value)

    delay_n_init = 130
    
    delay_n = delay_n_init

    m_light_select = 0xffa

    flashes_total = 18

    flashes_counter = 0

    top_level_loop = 0

    while flashes_counter < flashes_total:

        delay_quantity = get_delay_quantity(delay_set, flashes_counter)

        m_light_str = generate_m_light_asm(m_light_select, flashes_counter)

        intro = "\n".join([
            f"\n\nflash_{delay_n}",
            "ADD max",
            "STA &0FFF",
            m_light_str[0]
        ])

        first_delay = generate_delay_set(delay_n, 0, delay_quantity)

        second_delay = generate_delay_set(delay_n, 1, delay_quantity)

        seq = "\n\n".join([
            intro,
            first_delay,
            "STA &0FFF",
            second_delay,
            m_light_str[1]
        ])

        print(seq)

        m_light_select = get_next_m_light(m_light_select)

        delay_n -= 1

        flashes_counter += 1



def generate_m_light_asm(m_light_select, flashes_counter):

    m_light_select_str = format_input_mu0(m_light_select)

    m_light_pattern = get_next_m_light_pattern(flashes_counter)

    action_to_perform = flashes_counter % 18

    if action_to_perform < 6:
        
       ##  Load

        seq = "\n".join([
            f"LDA {m_light_pattern}",
            f"STA {m_light_select_str}",
            f"LDA zero",
            "\n"
        ])

        return [seq, ""]

    elif action_to_perform > 5 and action_to_perform < 12:

        seq = "\n".join([ f"STA {m_light_select}"])
        return ["", seq]        
            
    else:

        seq = "\n".join([ f"STA {m_light_select}"])
        return ["", seq]

        
def get_next_m_light_pattern(flashes_counter):

    if flashes_counter % 2 == 0:

        return "m_pattern_a"

    elif flashes_counter % 2 == 1:

        return "m_pattern_b"


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

    delay_asm = "\n".join([
        "LDA delay_max",
        delay_label,
        "sub one",
        f"JNE {delay_label}",
        "\n"
    ])
                 
    return delay_asm


def generate_pow_2_set(initial_value):

    delay_set = []

    v = initial_value

    while v > 0:

        delay_set.append(v)

        v = v // 2

    return delay_set


if __name__ == '__main__':
    
    main()

