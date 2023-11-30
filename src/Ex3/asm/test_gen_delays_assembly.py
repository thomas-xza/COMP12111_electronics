import unittest

from gen_delays_assembly import *

class Test_gen_assembly(unittest.TestCase):

    
    def test_generate_m_light_asm_valid(self):

        asm_string = generate_m_light_asm(0xffa, 0)

        expected_asm_str = ['LDA m_pattern_a\nSTA &FF9\nLDA zero', '']

        self.assertEqual(asm_string, expected_asm_str)

        
    def test_generate_m_light_asm_valid_2(self):

        asm_string = generate_m_light_asm(0xffa, 7)

        expected_asm_str = "\n".join(['', 'STA 4089'])

        self.assertEqual(asm_string, expected_asm_str)


    # def test_generate_m_light_asm_valid_2(self):

    #     asm_string = generate_m_light_asm(0xffa, 7)

    #     expected_asm_str = "\n".join(['', 'STA 4089'])

    #     self.assertEqual(asm_string, expected_asm_str)


if __name__ == '__main__':
    unittest.main()
